class SearchController < ApplicationController

  def index
    if params[:query].present?
      @repos = GithubService.search_repositories params[:query]
      @repos_imported = Repository.all.map(&:name)
      @current_repo_names = @repos['items'].map {|x| x['full_name']}
      @repos_matching = @repos_imported & @current_repo_names
    end
  end

end
