$(document).on("ready turbolinks:load", () => {
  memo_search();

  $("#q_memo_cont").on('input', () => {
    memo_search();
  });

  $(".icon_search").on('input', () => {
    memo_search();
  })

  // メモ検索のエンターで遷移しないようにする
  $('#q_memo_cont').on('keydown', (e) =>{
    if (e.which == 13) {
        return false
    };
  });

  $('#exampleModal').on('hidden.bs.modal', function () {
    data = []
    $check_boxs = $("#icon-search").find(".icon_search")
    $check_boxs.each((index, element) => {
      if($(element).prop("checked") == true){
        data.push(Number($(element).val()))
      }
    })

    // cssでチェックが入っているときはデザインを変更している
    if(data.length > 0){
      $('#detail-search').css('color', "#fff")
      $('#detail-search').css('background-color', "#6c757d")
      $('#detail-search').text("検索中..")
    }else{
      $('#detail-search').css('color', "")
      $('#detail-search').css('background-color', "")
      $('#detail-search').text("検索詳細")
    }
  })
});

// メモ欄の検索の反映
memo_search = () => {
  // チェックありのdaysのIDを取得して配列に格納
  data = []
  $check_boxs = $("#icon-search").find(".icon_search")
  $check_boxs.each((index, element) => {
    if($(element).prop("checked") == true){
      data.push(Number($(element).val()))
    }
  })

  $.ajax({
    url: '/months/search',  // リクエストを送信するURLを指定
    type: "POST",  // HTTPメソッドを指定（デフォルトはGET）
    data: {  // 送信するデータをハッシュ形式で指定
      q: {memo_cont: $("#q_memo_cont").val(),
          icon_eq_any: data
         }
    },
    dataType: "json"  // レスポンスデータをjson形式と指定する
  })
  .done((data) => {
    $trs = $("#search-list-days").find('.days')
    $trs.each((index, value) => {
      if(data.includes($(value).data("id"))){
        $(value).show()
      }else{
        $(value).hide()
      }
    })
  })
}