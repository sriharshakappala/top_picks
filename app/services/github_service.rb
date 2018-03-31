class GithubService

  DOMAIN = 'https://api.github.com'
  SEARCH_URL = '/search/repositories'

  def self.search_repositories repo
    query = "?q=#{repo}+language:javascript"
    url = URI(DOMAIN + SEARCH_URL + query)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
  end

end
