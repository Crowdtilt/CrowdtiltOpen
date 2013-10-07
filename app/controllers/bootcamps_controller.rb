class BootcampsController < ApplicationController

  def index
    @bootcamps=Bootcamp.all
  end

  def show
    @bootcamp=Bootcamp.find(params[:id])
  end

  def new
    @bootcamp=Bootcamp.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
