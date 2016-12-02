module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!, :configure_permitted_parameters
    skip_before_action :verify_authenticity_token
    before_action :set_user, only: [:show, :update, :destroy]
    http_basic_authenticate_with name: "ram", password: "Passw00rd"

    # GET /users
    def index
      @users = User.all

      render json: @users
    end

    # GET /users/1
    def show
      render json: @user
    end

    # POST /users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      if @user.destroy
        render json: { message: "User has been deleted successfully", status: 200 }
      else
        render json: { message: "Invalid user", status: 401 }
      end
    end

    # DELETE multiple users
    def delete_all
      ids = get_ids_from_params
      User.delete_all(["id in (?)", ids])
      index
    end

    # Post /users/validate
    def authenticate
      @user = User.find_by(username: user_params["username"])
      if @user.try(:valid_password?, user_params["password"])
        render json: { message: "Valid user", status: 200, token: @user.token }
      else
        render json: { message: "Invalid Login Credentials. Kindly check once...", status: 401 }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:first_name,
                                     :last_name,
                                     :email,
                                     :age,
                                     :address,
                                     :phone,
                                     :username,
                                     :password,
                                     :password_confirmation)
      end

     # collect user ids
     def get_ids_from_params
        params[:user_ids]
      end
  end
end