class ExilesController < ApplicationController
  layout 'exiles'

  respond_to :html

  before_filter :authorize_create, only: [:new, :create]
  before_filter :find_exile, only: [:show, :edit, :update, :destroy]
  before_filter :authorize_update, only: [:edit, :update, :destroy]

  def index
    @exiles = Exile.page(params[:page]).per(20)
  end

  def new
    @exile = Exile.new
  end

  def edit
  end

  def show

  end

  def create
    @exile = Exile.create(exile_params) do |exile|
      exile.user = current_user
    end

    if @exile.errors.any?
      render :edit
    else
      respond_with @exile
    end
  end

  def update
    @exile.update_attributes(exile_params)

    respond_with @exile
  end

  def destroy

  end

  private

  def exile_params
    params[:exile]
  end

  def find_exile
    @exile = Exile.find(params[:id])
  end

  def authorize_update
    authorize! :update, @exile
  end

  def authorize_create
    authorize! :create, Exile
  end
end
