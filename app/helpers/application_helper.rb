module ApplicationHelper

  #オプション引数にハッシュ{}形式で渡せないため、メソッド内で円グラフを生成
  def generate_chart(chart_date,color_options)
    chart_date = chart_date.reject { |key,value| value == 0 }
    chart_date_to_s = chart_date.map{ |key,value| [Day.parse_icon_to_s(key), value] }.to_h

    return pie_chart chart_date_to_s, 
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

  def icon_attribute(type)
    case type
    when "rent"
      return "fas fa-home"
    when "cost_of_living"
      return "fas fa-faucet"
    when "entertainment"
      return "fas fa-shopping-cart"
    when "food_expenses"
      return "fas fa-utensils"
    when "car_cost"
      return "fas fa-car-side"
    when "insurance"
      return "fas fa-hospital-user"
    when "other"
      return "fas fa-question-circle"
    when "payment"
        return "fas fa-yen-sign"
    else
      return ''
    end
  end

  def icon_color_attribute(type)
    case type
    when "rent"
      "icon-color-red"
    when "cost_of_living"
      "icon-color-lightblue"
    when "entertainment"
      "icon-color-green"
    when "food_expenses"
      "icon-color-yellow"
    when "car_cost"
      "icon-color-violetgreen"
    when "insurance"
      "icon-color-violet"
    when "other"
      "icon-color-gray"
    when "payment"
      "icon-color-gray"
    else
      return ""
    end
  end

  def bar_color_attribute(type)
    set_color = {}
    case type
    when "rent"
      "bg-danger"
    when "cost_of_living"
      "bg-primary"
    when "entertainment"
      "bg-success"
    when "food_expenses"
      "bg-warning"
    when "car_cost"
      "bg-violetgreen"
    when "insurance"
      "bg-violet"
    when "other"
      "bg-secondary"
    else
      return ""
    end
  end

  def day_adjust(day)
    if day.to_s.length == 1
      return "0#{day}"
    else
      return day.to_s
    end
  end

  def parse_percent(progress=0, spending=0)
    if progress == 0
      100
    else
      ((spending/progress.to_f)*100).ceil
    end
  end
end
