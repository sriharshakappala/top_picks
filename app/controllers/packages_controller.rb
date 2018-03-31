class PackagesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:import]

  def top
    @top_packages = Package.order('count DESC').limit(10)
  end

  def import
    response = GithubService.check_for_package_json(params['repo'], true)
    data = {:presence => response}
    render json: data
  end

end
