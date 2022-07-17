class ApplicationController < ActionController::Base
  helper_method :current_user,:current_month,:current_month_set,:donut_chart_color_set,:budget_set,:current_budget
  before_action :login_required
  # rescue_from Exception,                        with: :render_500
  # rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  # rescue_from ActionController::RoutingError,   with: :render_404


  private

  # def routing_error
  #   raise ActionController::RoutingError.new(params[:path])
  # end

  # def render_404(e = nil)
  #   logger.info "Rendering 404 with exception: #{e.message}" if e

  #   if request.xhr?
  #     render json: { error: '404 error' }, status: 404
  #   else
  #     format = params[:format] == :json ? :json : :html
  #     render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  #   end
  # end

  # def render_500(e = nil)
  #   logger.info "Rendering 500 with exception: #{e.message}" if e 

  #   if request.xhr?
  #     render json: { error: '500 error' }, status: 500
  #   else
  #     format = params[:format] == :json ? :json : :html
  #     render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  #   end
  # end







  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_month
    @current_month ||= Month.find_by(id: session[:month_id]) if session[:month_id]
  end

  def current_budget
    @current_budgets ||= current_month.budget
  end

  def current_month_set
    month = current_user.months.order(month_at: "DESC").first

    if month
      session[:month_id] = month.id
    else
      month = current_user.months.new(month_at: Time.zone.now)
      if month.save
        session[:month_id] = month.id
      end
    end
  end

  def login_required
    redirect_to users_path unless current_user
  end

  def donut_chart_color_set(chart_date)
    color_options = []
    chart_date.each do |date|
      case date[0]
        when "家賃"
          color_options << "#DA5019"
        when "生活費"
          color_options << "#4094be"
        when "食費"
          color_options << "#ddb500"
        when "娯楽費"
          color_options << "#20990e"
        when "自動車費"
          color_options << "darkolivegreen"
        when "保険"
          color_options << "violet"
        when "その他"
          color_options << "#8d8d8d"
      end
    end

    return color_options
  end


end
