// turbolinks:loadでページ読み込み時に実行
$(document).on("ready turbolinks:load", () => {


  // リストのドラッグアンドドロップで並べ替え ここから
  $( '#jquery-ui-sortable-home' ).sortable({
    cursor: "move",
    placeholder: "draglist",
    update: function( event, ui ) {
      lis = ui.item.parent().children(".ui-state-default");
      data = {}
      lis.each(function() {
        data[$(this).index()] = [$(this).data("content-type"),$(this).data("fix")]
      })

      setting_id = ui.item.parent().data("setting-id");
      postExpensesExpansion(setting_id, data);
    }
  });
  $( '.ui-state-highlight-home' ).draggable( {
    cursor: "move",
    connectToSortable: '#jquery-ui-sortable-home',
    helper: 'clone'
  });

  $( '#jquery-ui-sortable-date' ).sortable({
    cursor: "move",
    placeholder: "draglist",
    update: function( event, ui ) {
      lis = ui.item.parent().children(".ui-state-default");
      data = {}
      lis.each(function() {
        data[$(this).index()] = [$(this).data("content-type"),$(this).data("fix")]
      })

      setting_id = ui.item.parent().data("setting-id");
      postExpensesExpansion(setting_id, data);
    }
  });
  $( '.ui-state-highlight-date' ).draggable( {
    cursor: "move",
    connectToSortable: '#jquery-ui-sortable-date',
    helper: 'clone'
  });

  $( '#jquery-ui-sortable-bank' ).sortable({
    cursor: "move",
    placeholder: "draglist",
    update: function( event, ui ) {
      lis = ui.item.parent().children(".ui-state-default");
      data = {}
      lis.each(function() {
        data[$(this).index()] = [$(this).data("content-type"),$(this).data("fix")]
      })

      setting_id = ui.item.parent().data("setting-id");
      postExpensesExpansion(setting_id, data);
    }
  });
  $( '.ui-state-highlight-bank' ).draggable( {
    cursor: "move",
    connectToSortable: '#jquery-ui-sortable-bank',
    helper: 'clone'
  });

  $( '#jquery-ui-sortable-transition' ).sortable({
    cursor: "move",
    placeholder: "draglist",
    update: function( event, ui ) {
      lis = ui.item.parent().children(".ui-state-default");
      data = {}
      lis.each(function() {
        data[$(this).index()] = [$(this).data("content-type"),$(this).data("fix")]
      })

      setting_id = ui.item.parent().data("setting-id");
      postExpensesExpansion(setting_id, data);
    }
  });
  $( '.ui-state-highlight-transition' ).draggable( {
    cursor: "move",
    connectToSortable: '#jquery-ui-sortable-transition',
    helper: 'clone'
  });
  // リストのドラッグアンドドロップで並べ替え ここまで

  // ゴミ箱マーククリック時にその要素の削除とDBから対応するデータを削除する
  $(".click-delete").click(function() {
    $.ajax({
      url: "/users/delete_expansion",
      type: "POST",
      data: { id: $(this).data("id") }
    })

  })

  postExpensesExpansion = (id, lis_data) => {
    $.ajax({
      url: "/users/update_expansion",
      type: "POST",
      data: { setting_id: id, lis_data: lis_data }
    })
  }
});