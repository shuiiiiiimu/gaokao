class InfosController < ApplicationController

  def index
    @infos = Info.all.order(created_at: :desc).page(params[:page])
  end

  def show
    @info = Info.find params[:id]

    respond_to do |format|
      format.html
    end
  end

end
