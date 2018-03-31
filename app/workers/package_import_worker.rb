class PackageImportWorker
  include Sidekiq::Worker

  def perform content
    GithubService.extract_packages content
  end

end
