$(document).on("ready turbolinks:load", () => {

  $(".template-tr").on("click", (e) =>{
    template_checked(e);
  });

  template_checked = (e) => {
    $check_box = $($(e.target).siblings(".check-box-td").children("input")[0])
    if($check_box.prop("checked") == true){
      $check_box.prop("checked", false)
    }else{
      $check_box.prop("checked", true)
    }
  }
});