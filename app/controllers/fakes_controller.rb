class FakesController < ApplicationController
  before_action :authorize
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
    @fake = Fake.new(fake_params)
    if @fake.save
      redirect_to fakes_path
    else
      flash[:notice] = 'Возникли ошибки при создании.'
      render 'new'
    end
  end

  def new 
    @fake = Fake.new
  end

  def update 
    if @fake.update(fake_params)
      flash[:notice] = 'Фейк успешно обновлен.'
      redirect_to fakes_path
    else
      flash[:notice] = 'Возникли ошибки при редактировании.'
      render 'edit'
    end
  end

  def destroy
    if @fake.destroy
      flash[:notice] = 'Фейк успешно удален.'
      redirect_to fakes_path
    else
      flash[:notice] = 'Возникли ошибки при удалении.'
      redirect_to fakes_path
    end
  end

  def notify
    begin
      fake = Fake.find(params[:fake_id])
      service = Services::Fake.new(fake)
      service.notify
    rescue StandardError => e
      flash[:notice] = 'Сообщения не отправлены, возникли ошибки.'
    end

    redirect_to fakes_path
  end

  def set_new_friends_notified
    begin 
      fake = Fake.find(params[:fake_id])
      service = Services::Fake.new(fake)
      service.get_vk_friends(true)
      flash[:notice] = 'Все новые друзья помеченны уведомленными.'
    rescue StandardError => e
      flash[:notice] = 'Возникли ошибки.'
    end

    redirect_to fake_path(fake)
  end

  private

  def set_fake
    @fake = Fake.find(params[:id])
  end

  def fake_params 
    params.require(:fake).permit(:first_name, :last_name, :login, :password, 
                                 :vk_id, :schedule_notify, :message)
  end

end
