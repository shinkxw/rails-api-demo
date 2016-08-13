class ApplicationController < ActionController::API
  attr_accessor :current_user

  private

    def get_token_by_user(user)
      exp = Time.now.to_i + 7 * 24 * 3600#到期时间
      iat = Time.now.to_i#发行时间
      payload = { :id => user.id, :admin => user.admin, :exp => exp, :iat => iat }
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
      User.find(decoded_token[0]['id'])
    end

    def authenticate_jwt
      token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
      return unlogin_error if token.nil?
      user = get_user_by_token(token)
      if user
        self.current_user = user
      else
        return unlogin_error
      end
    end

    def current_user?(user)
      user == current_user
    end

    def unlogin_error
      render plain: "请先登录", status: :unauthorized
    end

    def unauthorize_error
      render plain: "用户未授权", status: :forbidden
    end

    def paginate(query, default_page_size = 30, default_page = 1)
      page = params[:page] ? params[:page].to_i : default_page
      page_size = params[:page_size] ? params[:page_size].to_i : default_page_size
      { data: query.limit(page_size).offset(page_size * (page - 1)), all_count: query.count }
    end
end
