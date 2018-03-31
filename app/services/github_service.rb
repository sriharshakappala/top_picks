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

  def self.check_for_package_json repo
    url = URI(RAW_FILE_DOMAIN + '/' + repo + '/master/package.json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    binding.pry
    if response.code == '200'
      return "Your job has added to queue. This repo will be imported shortly!"
    else
      return "This repo doesn't have any package.json file"
    end
  end

end
