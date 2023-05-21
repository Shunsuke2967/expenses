class ApplicationController < ActionController::Base
  helper_method :current_user,:current_expense,:current_expense_set,:donut_chart_color_set,:budget_set,:current_budget,:template_html,:current_demo
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

  def current_expense
    @current_expense ||= Expense.find_by(id: session[:expense_id]) if session[:expense_id]
  end

  def current_budget
    @current_budgets ||= current_expense.budget
  end

  def current_demo
    @demo ||= session[:demo]
  end

  def current_expense_set
    expense = current_user.expenses.order(date_at: "DESC").first

    if expense
      session[:expense_id] = expense.id
    else
      expense = current_user.expenses.new(date_at: Time.zone.now)
      if expense.save
        session[:expense_id] = expense.id
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
