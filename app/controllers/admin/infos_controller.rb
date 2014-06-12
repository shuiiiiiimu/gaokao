class Admin::InfosController < Admin::ApplicationController
  before_action :find_info, only: [:show, :edit, :update, :destroy]

  def index
    @infos = Info.order(created_at: :desc)
  end

  def show
  end

  def new
    @info = Info.new
  end

  def create
    @info = Info.new info_params

    if @info.save
      flash[:success] = I18n.t('admin.infos.flashes.successfully_created')
      redirect_to admin_info_path(@info)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @info.update_attributes info_params
      flash[:success] = I18n.t('admin.infos.flashes.successfully_updated')
      redirect_to admin_info_path(@info)
    else
      render :edit
    end
  end

  def destroy
    @info.destroy
    flash[:success] = I18n.t('admin.infos.flashes.successfully_destroy')
    redirect_to admin_infos_path
  end

  private

  def info_params
    params.require(:info).permit(:title, :source, :body)
  end

  def find_info
    @info = Info.find params[:id]
  end
end
