$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursorPointer');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;
  var idEnt = 0;

  function UpdateCursorPos() {
    $('#cursorPointer').css('left', cursorX);
    $('#cursorPointer').css('top', cursorY);
  }

  function triggerClick(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
    return true;
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Crosshair
    if(event.data.crosshair == true){
      $(".crosshair").addClass('fadeIn');
    }
    if(event.data.crosshair == false){
      $(".crosshair").removeClass('fadeIn');
    }

    // Menu
    if(event.data.menu == 'vehicle'){
      $(".crosshair").addClass('active');
      $(".menu-car").addClass('fadeIn');
      idEnt = event.data.idEntity;
    }
    if(event.data.menu == 'user'){
      $(".crosshair").addClass('fadeIn');
      $(".crosshair").addClass('active');
      $(".menu-user").addClass('fadeIn');
      idEnt = 0;
    }
    if((event.data.menu == false)){
      $(".crosshair").removeClass('fadeIn');
      $(".crosshair").removeClass('active');
      $(".menu").removeClass('fadeIn');
      idEnt = 0;
    }
    // Click
    if (event.data.type == "click") {
      triggerClick(cursorX - 1, cursorY - 1);
    }
  });

  // Mousemove
  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });


  $('.phone').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/togglephone', JSON.stringify({
      id: idEnt
    }));
  });
  $('.trunk').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/toggletrunk', JSON.stringify({
      id: idEnt
    }));
  });
  $('.inventory').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/toggleinventory', JSON.stringify({
      id: idEnt
    }));
  });
  $('.billing').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/togglebilling', JSON.stringify({
      id: idEnt
    }));
  });
  $('.emote').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/toggleemote', JSON.stringify({
      id: idEnt
    }));
  });
  $('.idcard').on('click', function(e){
    e.preventDefault();
    $.post('http://prc_menu/toggleidcard', JSON.stringify({
      id: idEnt
    }));
  });
  // Click Crosshair
  $('.crosshair').on('click', function(e){
    e.preventDefault();
    $(".crosshair").removeClass('fadeIn').removeClass('active');
    $(".menu").removeClass('fadeIn');
    $.post('http://prc_menu/disablenuifocus', JSON.stringify({
      nuifocus: false
    }));
  });

});
