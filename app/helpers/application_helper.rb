module ApplicationHelper

    #オプション引数にハッシュ{}形式で渡せないため、メソッド内で円グラフを生成
    def generate_chart(chart_date,chart_date_sum,color_options)
        return pie_chart chart_date, 
          donut: true, # ドーナツグラフ
          colors: color_options,
          message: {empty: "データがありません"},
          thousands: ",", 
          suffix: "円",
          legend: false, # 凡例非表示
          library: { # ここからHighchartsのオプション
            title: {
              text: "支出<br> #{chart_date_sum.to_s(:delimited)}円",
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
end
