class ApplicationController < ActionController::Base
  helper_method :current_user, :current_expense, :current_expense_set, :donut_chart_color_set, :budget_set, :template_html
  before_action :login_required

  if Rails.env.prodction?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  private

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_expense
    @current_expense ||= Expense.find_by(id: session[:expense_id])
  end

  def current_expense_set
    expense = current_user.expenses.order(date_at: 'DESC').first || current_user.expenses.create(date_at: Time.current)
    session[:expense_id] = expense.id
  end

  def login_required
    redirect_to users_path unless current_user
  end

  # donutchartの色の決める
  def donut_chart_color_set(total_spending)
    color_options = []
    total_spending.each do |date|
      case date[0]
      when :rent
        color_options << '#DA5019'
      when :cost_of_living
        color_options << '#4094be'
      when :food_expenses
        color_options << '#ddb500'
      when :entertainment
        color_options << '#20990e'
      when :car_cost
        color_options << 'darkolivegreen'
      when :insurance
        color_options << 'violet'
      when :other
        color_options << '#8d8d8d'
      end
    end
    color_options
  end
end
