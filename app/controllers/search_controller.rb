class SearchController < ApplicationController

  def index
    if params[:query].present?
      @repos = GithubService.search_repositories params[:query]
    end
  end

end
