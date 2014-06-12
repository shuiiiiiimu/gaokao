class HomeController < ApplicationController
  def index
    @flag = true
    puts "----------------------HomeController--------------------------------"
    # render layout:false
  end
end
