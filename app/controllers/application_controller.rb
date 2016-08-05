class ApplicationController < ActionController::API
  attr_accessor :current_user

  def get_token_by_user(user)
    exp = Time.now.to_i + 7 * 24 * 3600#到期时间
    iat = Time.now.to_i#发行时间
    payload = { :id => user.id, :exp => exp, :iat => iat }
    JWT.encode(payload, Jwt_hmac_secret, 'HS256')
  end

  def get_user_by_token(token)
    begin
      decoded_token = JWT.decode(token, Jwt_hmac_secret, true, { :algorithm => 'HS256' })
    rescue JWT::VerificationError#token无效
      return nil
    rescue JWT::ExpiredSignature#token过期
      return nil
    end
    User.find(decoded_token[0]['user_id'])
  end

  def authenticate_jwt
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    return unauthorize_error if token.nil?
    user = get_user_by_token(token)
    if user
      self.current_user = user
    else
      return unauthorize_error
    end
  end

  def unauthorize_error
    render plain: "用户未授权", status: :unauthorized
  end
end
