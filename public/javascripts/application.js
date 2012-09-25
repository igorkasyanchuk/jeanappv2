$(function() {
  $("select, input, textarea, input:checkbox, input:radio, input:file").uniform(); 
  $('.date_picker').datepicker({
    showOn: 'both',
    buttonImage: '/images/calendar_3.png',
    buttonImageOnly: true,
    dateFormat: "yy-mm-dd",
    numberOfMonths: 2
  });
  $('.single_date_picker').datepicker({
    showOn: 'both',
    buttonImage: '/images/calendar_3.png',
    buttonImageOnly: true,
    dateFormat: "yy-mm-dd",
    numberOfMonths: 1
  });
  $('.dob_picker').datepicker({
    showOn: 'both',
    buttonImage: '/images/calendar_3.png',
    buttonImageOnly: true,
    dateFormat: "d MM",
    numberOfMonths: 2
  });  
  $('.flash').delay(3000).slideUp('fast').live('click', function() {$(this).slideUp('fast')});
  handle_enters();
});

function handle_enters() {
  $('input').live('keypress', function(e) {
    c = e.which ? e.which : e.keyCode;
    if (c == 13) {
      $(this).parents("form").submit();
    };
  });
};

function init_add_form() {
  $('.add a').live('click', function() {
    var _this = $(this);
    var to = $(_this.attr('to'));
    var targetOffset = to.offset().top + 300 + 'px';
    to.slideDown('fast').find('a').click(function() {
      to.slideUp('fast');
      _this.parent().show();
      return false;
    });
    _this.parent().hide();
    $('html,body').animate({scrollTop: targetOffset}, 1000);
    return false;
  });
};

function refreshChart(d,project_name) {
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Time');
  data.addColumn('number', 'Hours');
  data.addRows(3);
  data.setValue(0, 0, 'Profit');
  data.setValue(0, 1, d[0]);
  data.setValue(1, 0, 'Developers');
  data.setValue(1, 1, d[1]);
  data.setValue(2, 0, 'Expenses');
  data.setValue(2, 1, d[2]);
  document.getElementById('chart_div').innerHTML = '';
  var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
  chart.draw(data, {width: 500, height: 370, title: project_name});
}

var CENTER_OF_THE_WORLD_LAT = 30;
var CENTER_OF_THE_WORLD_LNG = 20;

var info_window;
var boss_icon;
var person_icon;
var client_icon;
var map;

function show_clients_on_map(center, clients) {
  $('#map').show();
  map = new GMap2(document.getElementById('map'));

  map.setMapType(G_SATELLITE_MAP);
  var daylight = new daylightMap.daylightLayer();
  daylight.addToMap(map);  

  map.setCenter(new GLatLng(30, 20), 2, G_SATELLITE_MAP);
  map.setCenter(new GLatLng(30, 20), 2, G_NORMAL_MAP);

  init_map_base();
  add_boss_icon(center);
  $.each(clients, function() {
    add_client_icon(this);
  });  
};

function show_people_on_map(center, people) {
  $('#map').show();
  map = new GMap2(document.getElementById('map'));

  map.setMapType(G_SATELLITE_MAP);
  var daylight = new daylightMap.daylightLayer();
  daylight.addToMap(map);  

  map.setCenter(new GLatLng(30, 20), 2, G_SATELLITE_MAP);
  map.setCenter(new GLatLng(30, 20), 2, G_NORMAL_MAP);

  init_map_base();
  add_boss_icon(center);
  $.each(people, function() {
    add_person_icon(this);
  });  
};

function add_boss_icon(info) {
  marker_options = { icon: boss_icon };
  var position = new GLatLng( info.lat, info.lng );
  var boss_marker = new GMarker( position, marker_options );
  map.addOverlay(boss_marker);
  GEvent.addListener(boss_marker, "click", function() {
    this.tooltip.hide();
    boss_marker.openInfoWindowHtml("<div class='info_window'><h1>" + info.name + "</h1></div>");
  });
  
  var tooltip = new Tooltip(boss_marker, info.name, 4); 
  boss_marker.tooltip = tooltip; 
  map.addOverlay(tooltip);   
  GEvent.addListener(boss_marker, 'mouseover', function() { this.tooltip.show(); } ); 
  GEvent.addListener(boss_marker, 'mouseout', function() { this.tooltip.hide(); } );  
};

function add_person_icon(info) {
  var _html = "<div class='info_window'><h1>" + info.name + "</h1>" + 
      "<strong>" + info.role + "</strong>" + 
      "<div>Local Time: " + info.local_time +"</div>"+
      "<a href=" + info.id + ">View Profile &rarr;</a>"+
      "</div>";
  marker_options = { icon: person_icon};
  var position = new GLatLng( info.lat, info.lng );
  var person_marker = new GMarker( position, marker_options );
  map.addOverlay(person_marker);
  GEvent.addListener(person_marker, "click", function() {
    this.tooltip.hide();
    var _info = _html;
    person_marker.openInfoWindowHtml(_info);
  });
  var tooltip = new Tooltip(person_marker, info.name, 4); 
  person_marker.tooltip = tooltip; 
  map.addOverlay(tooltip);   
  GEvent.addListener(person_marker, 'mouseover', function() { this.tooltip.show(); } ); 
  GEvent.addListener(person_marker, 'mouseout', function() { this.tooltip.hide(); } );  
}

function add_client_icon(info) {
  var _html = "<div class='info_window'><h1>" + info.name + "</h1>" + 
      "<div>Local Time: " + info.local_time +"</div>"+
      "<a href=" + info.id + ">View Profile &rarr;</a>"+
      "</div>";
  marker_options = { icon: client_icon};
  var position = new GLatLng( info.lat, info.lng );
  var client_marker = new GMarker( position, marker_options );
  map.addOverlay(client_marker);
  GEvent.addListener(client_marker, "click", function() {
    this.tooltip.hide();
    var _info = _html;
    client_marker.openInfoWindowHtml(_info);
  });
  var tooltip = new Tooltip(client_marker, info.name, 4); 
  client_marker.tooltip = tooltip; 
  map.addOverlay(tooltip);   
  GEvent.addListener(client_marker, 'mouseover', function() { this.tooltip.show(); } ); 
  GEvent.addListener(client_marker, 'mouseout', function() { this.tooltip.hide(); } );  
}

function init_map_base() {
  boss_icon = new GIcon(G_DEFAULT_ICON);
  boss_icon.image = '/images/pins/red.png';
  boss_icon.iconSize = new GSize(32, 32);
  boss_icon.shadowSize = new GSize(32, 32);
  boss_icon.iconAnchor = new GPoint(15, 28);
  boss_icon.infoWindowAnchor = new GPoint(15, 1);   
  person_icon = new GIcon(G_DEFAULT_ICON);
  person_icon.image = '/images/pins/blue.png';
  person_icon.iconSize = new GSize(32, 32);
  person_icon.shadowSize = new GSize(32, 32);
  boss_icon.iconAnchor = new GPoint(15, 28);
  person_icon.infoWindowAnchor = new GPoint(15, 1);
  client_icon = new GIcon(G_DEFAULT_ICON);
  client_icon.image = '/images/pins/yellow.png';
  client_icon.iconSize = new GSize(32, 32);
  client_icon.shadowSize = new GSize(32, 32);
  boss_icon.iconAnchor = new GPoint(15, 28);
  client_icon.infoWindowAnchor = new GPoint(15, 1);    
};

function init_projects_filter(url) {
  $('#projects_filter').change(function() {
    window.location = url + '?filter=' + $(this).val();
  });
};

function init_earnings_filter(url) {
  $('#earnings_filter').change(function() {
    window.location = url + '?filter=' + $(this).val() + "&start=" + $('#start_earnings_chart').val() + "&end=" + $('#end_earnings_chart').val();
  });
};

function init_project_on_off() {
  $('.project_on_off').click(function() {
    window.location = $(this).attr('url');
    return false;
  });
};

function draw_earnings_chart(ROWS) {
  google.load("visualization", "1", {packages:["corechart"]});
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Week');
  data.addColumn('number', 'Budget');
  data.addColumn('number', 'Profit');
  data.addColumn('number', 'Employees');
  data.addColumn('number', 'Expenses');
  data.addRows(ROWS.length);
  $.each(ROWS, function(index, e) {
    data.setValue(index, 0, e[0]);
    data.setValue(index, 2, e[1]);
    data.setValue(index, 1, e[2]);
    data.setValue(index, 3, e[3]);
    data.setValue(index, 4, e[4]);
  });
  var chart = new google.visualization.LineChart(document.getElementById('chart_table'));
  chart.draw(data, {width: '100%',
                    height: 570, 
                    colors: ['blue', 'green', 'red', '#FF9900'], 
                    fontSize: '10px', 
                    legendTextStyle: {fontSize: '14px'},
                    titleTextStyle: {fontSize: '18px'},
                    tooltipTextStyle: {fontSize: '14px'}
                  });
}

function init_update_chart() {
  $('#update_earhings_chart').click(function() {
    _url = $(this).attr('data');
    if ($('#start_earnings_chart').val() != '' && $('#end_earnings_chart').val() != '') {
      window.location = _url + "?start=" + $('#start_earnings_chart').val() + "&end=" + $('#end_earnings_chart').val() + "&filter=" + $('#earnings_filter').val();
    }
  });
};

function init_add_invoice() {
   $('.add_invoice_button').live('click', function() {
     $.fn.colorbox({href: '#invoice_form_container', inline: true, width: '800px'}); 
     return false;
   });
   $('#invoice_form_container .hide').bind('click', function() {
     $.colorbox.close();
     return false;
   });
   $('.add_invoice2').attr('href', '').click(function(e) {
     $('.add_invoice_button').trigger('click');
     return false;
   });
};

function init_manage_employees() {
   $('#manage_employees_container .hide').bind('click', function() {
     $.colorbox.close();
     return false;
   });
   $('.manage_employees').attr('href', '').click(function(e) {
     $.fn.colorbox({href: '#manage_employees_container', inline: true, width: '800px'}); 
     return false;
   });
};

function init_calendar_form() {
  $('td.day:not(.total_sum)').live('click', function() {
     form = '#day-form-' + $(this).attr('data-day-id') + ' form';
     $.fn.colorbox({href: form, inline: true, width: '500px', onComplete: function() {  $('#cboxLoadedContent #user_money_amount').focus(); }});
     return false;
  });
  $('.hide').live('click', function() {
    $.colorbox.close();
  });
  calculate_total_sum();
  init_calendar_ajax_controls();
};

function init_time_view() {
  calculate_time_sum();
};

function calculate_time_sum() {
  $.each($('td.total_sum'), function() {
    td = $(this);
    var mine = 0;
    var contractors = 0;
    $.each(td.parents('tr').find('.time_cell'), function() {
      r = $(this).text().replace('$', '').replace(',', '').split("/")
      mine += parseFloat(r[0]);
      contractors += parseFloat(r[1]);
    });
    var span = $("<span/>", {
      text: mine + " / " + contractors,
    });
    td.text('').append(span);
  });
};

function init_calendar_ajax_controls() {
  $('.ajax_loader').hide();
  $('.ajax_controls').show();
  $('.new_user_money').live('submit', function() {
    $(this).find('.ajax_controls').hide().end().find('.ajax_loader').show();
  });
  $('.delete_row_link').live('click', function() {
    $(this).hide().next().show();
  });
};

function calculate_total_sum() {
  $.each($('td.total_sum'), function() {
    td = $(this);
    var sum = 0;
    $.each(td.parents('tr').find('td.day > span'), function() {
      sum += parseFloat($(this).text().replace('$', '').replace(',', ''));
    });
    var span = $("<span/>", {
      "class": ( (sum > 0) ? 'plus_sign' : ( (sum == 0) ? 'zero_sign' : 'minus_sign') ),
      text: ('$' + numberToCurrency(sum)).replace('$-', '-$').replace('.00', ''),
    });
    td.text('').append(span);
  });
};

/**
 * Converts number into currency format
 * @param {number} number   Number that should be converted.
 * @param {string} [decimalSeparator]    Decimal separator, defaults to '.'.
 * @param {string} [thousandsSeparator]    Thousands separator, defaults to ','.
 * @param {int} [nDecimalDigits]    Number of decimal digits, defaults to `2`.
 * @return {string} Formatted string (e.g. numberToCurrency(12345.67) returns '12,345.67')
 */
function numberToCurrency(number, decimalSeparator, thousandsSeparator, nDecimalDigits){
  //default values
  decimalSeparator = decimalSeparator || '.';
  thousandsSeparator = thousandsSeparator || ',';
  nDecimalDigits = nDecimalDigits || 2;

  var fixed = number.toFixed(nDecimalDigits), //limit/add decimal digits
    parts = RegExp('^(-?\\d{1,3})((\\d{3})+)\\.(\\d{'+ nDecimalDigits +'})$').exec( fixed ); //separate begin [$1], middle [$2] and decimal digits [$4]

  if(parts){ //number >= 1000 || number <= -1000
    return parts[1] + parts[2].replace(/\d{3}/g, thousandsSeparator + '$&') + decimalSeparator + parts[4];
  }else{
    return fixed.replace('.', decimalSeparator);
  }
}

function show_money_chart(c) {
  var r = Raphael("money_holder");
  r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
  legend = [c[0].title, c[1].title,  c[2].title];
  colors = [c[0].color, c[1].color,  c[2].color];
  values = [c[0].value, c[1].value,  c[2].value];
  
  if (values[1] == 0 && values[2] == 0) {
    values = [100];
    legend = ["%% Profit"];
    colors = ["#1C7B1C"];
  }

  var pie = r.g.piechart(120, 110, 100, values, {legend: legend, legendpos: "south", colors: colors});
  pie.hover(function () {
      this.sector.stop();
      this.sector.scale(1.1, 1.1, this.cx, this.cy);
      if (this.label) {
          this.label[0].stop();
          this.label[0].scale(1.5);
          this.label[1].attr({"font-weight": 800});
      }
  }, function () {
      this.sector.animate({scale: [1, 1, this.cx, this.cy]}, 500, "bounce");
      if (this.label) {
          this.label[0].animate({scale: 1}, 500, "bounce");
          this.label[1].attr({"font-weight": 400});
      }
  });
};

function show_time_chart(chart) {
  var r = Raphael("time_holder");
  r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";
  legend = ["%%.%% My Hours", "%%.%% Employee Hours"];
  if (chart[1] == 0) {
    chart = [100];
    legend = ["%% My Hours"];
  }
  var pie = r.g.piechart(120, 110, 100, chart, {legend: legend, legendpos: "south", colors: ["#1C7B1C", "#004A7F"]});
  pie.hover(function () {
      this.sector.stop();
      this.sector.scale(1.1, 1.1, this.cx, this.cy);
      if (this.label) {
          this.label[0].stop();
          this.label[0].scale(1.5);
          this.label[1].attr({"font-weight": 800});
      }
  }, function () {
      this.sector.animate({scale: [1, 1, this.cx, this.cy]}, 500, "bounce");
      if (this.label) {
          this.label[0].animate({scale: 1}, 500, "bounce");
          this.label[1].attr({"font-weight": 400});
      }
  });
};

function init_project_show_page() {
  $("strong.expand").live("click", function() {  $( $(this).attr("data-class") ).slideToggle(); $(this).toggleClass('expand_up'); });
};

function init_own_hours_stopwatch() {
  var container =  $('.stopwatch span')
  var init_value = container.html()
  container.stopwatch().stopwatch('destroy')
  if(init_value.replace('') != ''){
    container.stopwatch({startTime: Number(init_value)}).stopwatch('start')
    setTimeout(function() {container.parent().removeClass('none')}, 1000)
  }
}

function start_own_hours_stopwatch(){
  var container =  $('.stopwatch span')
  container.html('0')
  init_own_hours_stopwatch()
  container.parent().removeClass('none');
}

function stop_own_hours_stopwatch(){
  var container =  $('.stopwatch span')
  container.stopwatch().stopwatch('destroy')
  container.html('')
  container.parent().addClass('none');
}
