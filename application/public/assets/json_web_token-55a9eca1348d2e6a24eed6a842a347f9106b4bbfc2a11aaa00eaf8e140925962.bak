skip_before_action :authenticate_request

def auth
  user = AuthenticateUser.call(params[:email], params[:password])

  if user.success?
    render json: user
  else
    render json: { errors: ["wrong username or password"] }, status: :unauthorized
  end
end