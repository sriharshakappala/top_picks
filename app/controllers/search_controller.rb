class SearchController < ApplicationController

  def index
    if params[:query].present?
      GithubService.search
    end
  end

end
