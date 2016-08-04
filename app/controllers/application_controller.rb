class ApplicationController < ActionController::API
  def get_token_by_user(user)
    exp = Time.now.to_i + 7 * 24 * 3600#到期时间
    iat = Time.now.to_i#发行时间
    payload = { :user_id => user.id, :exp => exp, :iat => iat }
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
end
