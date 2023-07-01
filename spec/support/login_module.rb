module RequestSpecHelper
  def login(user)
    post sessions_path, params: { session: { email: user.email, password: user.password } }
  end
end
