module ApplicationHelper

  #オプション引数にハッシュ{}形式で渡せないため、メソッド内で円グラフを生成
  def generate_chart(chart_date,color_options)
    chart_date = chart_date.reject { |key,value| value == 0 }
    return pie_chart chart_date, 
      donut: true, # ドーナツグラフ
      colors: color_options,
      message: {empty: "データがありません"},
      thousands: ",", 
      suffix: "円",
      legend: false, # 凡例非表示
      library: { # ここからHighchartsのオプション
        title: {
          text: "支出<br> #{chart_date&.values&.inject(:+)&.to_s(:delimited)}円",
          align: 'center',
          verticalAlign: 'middle',
        },
        chart: {
          backgroundColor: 'none',
          plotBorderWidth: 0, 
          plotShadow: false
        },
        plotOptions: {
          pie: {
            dataLabels: {
              enabled: true, 
              distance: 5, # ラベルの位置調節
              allowOverlap: false, # ラベルが重なったとき、非表示にする
              style: { #ラベルフォントの設定
                color: 'lightgray',
                textAlign: 'center', 
                textOutline: 0, #デフォルトではラベルが白枠で囲まれていてダサいので消す
              }
            },
            innerSize: '57%', # ドーナツグラフの中の円の大きさ
            size: '75%',
            borderWidth: 0,
          }
        },
      }
  end

  def icon_selector(item_s)
    case item_s
    when "家賃","rent"
      return "fas fa-home"
    when "生活費","cost_of_living"
      return "fas fa-faucet"
    when "娯楽費","entertainment"
      return "fas fa-shopping-cart"
    when "食費","food_expenses"
      return "fas fa-utensils"
    when "自動車費","car_cost"
      return "fas fa-car-side"
    when "保険","insurance"
      return "fas fa-hospital-user"
    when "その他","others"
      return "fas fa-question-circle"
    when "入金","payment"
        return "fas fa-yen-sign"
    else
      return 0
    end
  end

  def color_selector(item_s)
    set_color = {}
    case item_s
    when "家賃","rent"
      set_color[:icon] = "icon-color-red"
      set_color[:progress] = "bg-danger"
    when "生活費","cost_of_living"
      set_color[:icon] = "icon-color-lightblue"
      set_color[:progress] = "bg-primary"
    when "娯楽費","entertainment"
      set_color[:icon] = "icon-color-green"
      set_color[:progress] = "bg-success"
    when "食費","food_expenses"
      set_color[:icon] = "icon-color-yellow"
      set_color[:progress] = "bg-warning"
    when "自動車費","car_cost"
      set_color[:icon] = "icon-color-violetgreen"
      set_color[:progress] = "bg-violetgreen"
    when "保険","insurance"
      set_color[:icon] = "icon-color-violet"
      set_color[:progress] = "bg-violet"
    when "その他","others"
      set_color[:icon] = "icon-color-gray"
      set_color[:progress] = "bg-secondary"
    when "入金","payment"
      set_color[:icon] = "icon-color-gray"
    else
      return ""
    end

    return set_color
  end

  def day_adjust(day)
    if day.to_s.length == 1
      return "0#{day}"
    else
      return day.to_s
    end
  end

  # 部分テンプレートに渡すローカル変数のhashを作成

  def locals_date(content, datas,setting_type) 
    case content.content_type
    when "budget"
      return {
        total_spending_list: datas[:total_spending_list],
        current_sum: datas[:current_sum],
        setting_type: setting_type
      }

    when "template"
      return { setting_type: setting_type }

    when "bank_balance"
      return {
        income_and_expenditure: datas[:income_and_expenditure],
        current_income_and_expenditure: datas[:current_income_and_expenditure],
        setting_type: setting_type
      }

    when "spending_chart_date"
      return {
        total_spending_list: datas[:total_spending_list],setting_type: setting_type
      }

    when "income_and_expenditure_transition"
      return { setting_type: setting_type }

    when "bank_balance_transition"
      return { setting_type: setting_type }
    
    when "current_income_and_expenditure"
      return {
        current_days: datas[:current_days],
        current_month_incomes_sum: datas[:current_sum][:incomes_sum],
        current_month_spending_sum: datas[:current_sum][:spending_sum],
        current_month_computation: datas[:current_sum][:computation],
        setting_type: setting_type
      }

    when "list_of_details"
      return { current_days: datas[:current_days], setting_type: setting_type }

    when "current_salary"
      return { setting_type: setting_type }
      
    else
    end
  end
end
