$(function() {
  $('.tab').click(function(){
    console.log(this)
    $('.active').removeClass('active');
    $(this).addClass('active');
    $('.box-show').removeClass('box-show');
    const index = $('a.tab.nav-link').index(this);
    console.log(index)
    $('.tabbox').eq(index).addClass('box-show');
  });
});
