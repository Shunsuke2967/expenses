$(document).on("ready turbolinks:load", () => {
  $(function(){
    $("#first-contact").show();
    if($("#first-contact").data("first-user")){
      $('#modal-options').iziModal('open');
    }
  });

  $('#first-modal').on('click', () => {
    $('#modal-options').iziModal('open');
  });
  
  $('#modal-options').iziModal({
    headerColor: '#26A69A', //ヘッダー部分の色
    overlayColor: 'rgba(0, 0, 0, 0.5)', //モーダルの背景色
    transitionIn: 'fadeInRight', //表示される時のアニメーション
    transitionOut: 'fadeOutRight' //非表示になる時のアニメーション
  });
});