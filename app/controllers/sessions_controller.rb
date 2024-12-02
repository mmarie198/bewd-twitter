class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:user][:username])

    if @user&.authenticate(params[:user][:password])
      @session = @user.sessions.create!
      
      # Ensure consistent use of permanent cookie
      cookies.permanent[:twitter_session_token] = {
        value: @session.token,
        httponly: true
      }

      render json: { 
        session: {
          id: @session.id,
          token: @session.token,
          user_id: @user.id
        }
      }, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def authenticated
    session_token = cookies.permanent[:twitter_session_token]
    @session = Session.find_by(token: session_token)

    if @session
      render json: { 
        authenticated: true,
        user: {
          id: @session.user.id,
          username: @session.user.username,
          email: @session.user.email
        }
      }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  def destroy
    session_token = cookies.permanent[:twitter_session_token]
    @session = Session.find_by(token: session_token)

    if @session
      @session.destroy
      cookies.permanent.delete(:twitter_session_token)
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { error: 'No active session' }, status: :not_found
    end
  end
end
