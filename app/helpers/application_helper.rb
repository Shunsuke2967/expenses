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
    when "家賃"
      return "fas fa-home"
    when "生活費"
      return "fas fa-faucet"
    when "娯楽費"
      return "fas fa-shopping-cart"
    when "食費"
      return "fas fa-utensils"
    when "自動車費"
      return "fas fa-car-side"
    when "保険"
      return "fas fa-hospital-user"
    when "その他"
      return "fas fa-question-circle"
    else
      return 0
    end
  end

  def color_selector(item_s)
    set_color = {}
    case item_s
    when "家賃"
      set_color[:icon] = "icon-color-red"
      set_color[:progress] = "bg-danger"
    when "生活費"
      set_color[:icon] = "icon-color-lightblue"
      set_color[:progress] = "bg-primary"
    when "娯楽費"
      set_color[:icon] = "icon-color-green"
      set_color[:progress] = "bg-success"
    when "食費"
      set_color[:icon] = "icon-color-yellow"
      set_color[:progress] = "bg-warning"
    when "自動車費"
      set_color[:icon] = "icon-color-violetgreen"
      set_color[:progress] = "bg-violetgreen"
    when "保険"
      set_color[:icon] = "icon-color-violet"
      set_color[:progress] = "bg-violet"
    when "その他"
      set_color[:icon] = "icon-color-gray"
      set_color[:progress] = "bg-secondary"
    else
      return ""
    end

    return set_color
  end
end
