module Api
  class RegistrationsController < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

    def create
      user = User.new(user_params)

      if user.save
        @userData = User.find(user.id)
        my_data = {status: 1, user: {id: user.id, token: @userData.authentication_token }}
        render :json=> my_data, :status=> 201
        return
      else
        warden.custom_failure!
        render :json=> user.errors, :status=>422
      end
    end
    private
    def user_params
      params.require(:registration).permit(:email, :password)
    end
  end
end
