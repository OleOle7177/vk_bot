class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Вход выполнен успешно!'
    else 
      flash.now.alert = 'Неверное имя пользователя или пароль'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: 'Выход!'
  end
end
