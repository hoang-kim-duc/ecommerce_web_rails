import 'ion-rangeslider'

$('#limit_price').ionRangeSlider({
  skin: "round",
  type: "double",
  grid: true,
  min: $('#slider_min').val(),
  max: $('#slider_max').val(),
  from: $('#slider_from').val(),
  to: $('#slider_to').val()
});

$('#sort').on('change', function() {
  $("#display_option").submit();
});
