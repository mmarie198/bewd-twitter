class TweetsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def index
      @tweets = Tweet.all.order(created_at: :desc)
      render json: @tweets, include: { user: { only: [:username] } }
    end
  
    def index_by_user
      @user = User.find_by(username: params[:username])
      
      if @user
        @tweets = @user.tweets.order(created_at: :desc)
        render json: @tweets
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  
    def create
      @tweet = current_user.tweets.build(tweet_params)
  
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @tweet = current_user.tweets.find_by(id: params[:id])
  
      if @tweet
        @tweet.destroy
        render json: { message: 'Tweet deleted successfully' }, status: :ok
      else
        render json: { error: 'Tweet not found or unauthorized' }, status: :not_found
      end
    end
  
    private
  
    def tweet_params
      params.require(:tweet).permit(:message)
    end
  
    def authenticate_user!
      session_token = cookies[:twitter_session_token]
      @current_session = Session.find_by(token: session_token)
  
      unless @current_session
        render json: { error: 'Unauthorized' }, status: :unauthorized
        return false
      end
    end
  
    def current_user
      @current_session&.user
    end
  end
