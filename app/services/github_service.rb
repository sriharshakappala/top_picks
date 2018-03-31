class GithubService

  DOMAIN = 'https://api.github.com'
  SEARCH_URL = '/search/repositories'
  RAW_FILE_DOMAIN = 'https://raw.githubusercontent.com'

  def self.search_repositories repo
    return JSON.parse($redis.get(repo)) if $redis.get(repo).present?
    query = "?q=#{repo}+language:javascript"
    url = URI(DOMAIN + SEARCH_URL + query)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    results = response.read_body
    $redis.set(repo, results)
    return JSON.parse(results)
  end

  def self.check_for_package_json repo, extract = false
    url = URI(RAW_FILE_DOMAIN + '/' + repo + '/master/package.json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    if response.code == '200'
      PackageImportWorker.perform_async(repo, JSON.parse(response.read_body))
      return true
    else
      return false
    end
  end

  def self.extract_packages repo, content
    Repository.create(name: repo)
    if content['dependencies'].present?
      content['dependencies'].each do |dependency|
        package = Package.find_by_name(dependency[0])
        if package.present?
          package.update(count: (package.count.to_i + 1))
        else
          Package.create(name: dependency[0], count: 1)
        end
      end
    end
  end

end
