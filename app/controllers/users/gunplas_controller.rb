class Users::GunplasController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update)
  def index
  end

  def show
  end

  def new
    @gunpla = Gunpla.new
  end

  def create
  end

  def edit
  end

  def update
  end
end
