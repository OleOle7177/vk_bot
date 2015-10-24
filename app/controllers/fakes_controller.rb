class FakesController < ApplicationController
  before_action :set_fake, only: [:show, :edit, :update, :destroy, 
                                  :send_message]

  def index 
    @fakes = Fake.all
  end

  def show
  end

  def edit
  end

  def create
  end

  def new 
  end

  def update 
  end

  def destroy
  end

  def send_message
  end


  private

  def set_fake
    @fake = Fake.find(params[:id])
  end

  def fake_params 
    params.require(:fake).permit(:first_name, :last_name, :login, :password, )
  end

end
