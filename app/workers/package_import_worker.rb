class PackageImportWorker
  include Sidekiq::Worker

  def perform repo, content
    GithubService.extract_packages repo, content
  end

end
