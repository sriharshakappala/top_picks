class PackagesController < ApplicationController

  def top
    @top_packages = Package.order('count DESC').limit(10)
  end

  def import
    binding.pry
  end

end
