module Admin
  class BroadcastsController < AdminController

    respond_to :html

    before_filter :find_broadcast, only: [:show, :edit, :update, :destroy]

    def index
      @broadcasts = Broadcast.page(params[:page]).per(10)
    end

    def show

    end

    def new
      @broadcast = Broadcast.new
    end

    def create
      @broadcast = Broadcast.new(params[:broadcast])
      @broadcast.save
      respond_with @broadcast, location: [:admin, @broadcast]
    end

    def edit

    end

    def update
      @broadcast.update_attributes(params[:broadcast])
      respond_with @broadcast, location: [:admin, @broadcast]
    end

    def destroy
      @broadcast.destroy
      respond_with @broadcast, location: admin_broadcasts_url
    end

    private

    def find_broadcast
      @broadcast = Broadcast.find(params[:id])
    end

  end
end
