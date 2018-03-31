class GithubService

  DOMAIN = 'https://api.github.com'
  SEARCH_URL = '/search/repositories'

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

end
