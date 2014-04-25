class ExilesController < ApplicationController
  layout 'exiles'

  before_filter :find_exile, only: [:show]

  def index
  end

  def show

  end

  private

  def find_exile
    @exile = Exile.find(params[:id])
  end
end
