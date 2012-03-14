function show_people_on_map_v3(center, people) {
  var latlng = new google.maps.LatLng(center.lat, center.lng);
  var myOptions = {
    zoom: 2,
    center: new google.maps.LatLng(CENTER_OF_THE_WORLD_LAT, CENTER_OF_THE_WORLD_LNG),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDefaultUI: false
  };
  var map = new google.maps.Map(document.getElementById("map"), myOptions);
  info_window = new google.maps.InfoWindow({ content: '' });
  $('#map').show();
  $.each(people, function() {
    add_person_icon(this, map);
  });
  add_boss_icon(center, map);
  var daylight = new daylightMap.daylightLayer();
  daylight.addToMap(map);
  daylight.addToMapType(google.maps.MapTypeId.ROADMAP);
};

function add_boss_icon_v3(info, map) {
  var image = '/images/pins/red.png';
  var position = new google.maps.LatLng(info.lat, info.lng);
  var boss_marker = new google.maps.Marker({
      position: position,
      map: map,
      icon: image
  });
  google.maps.event.addListener(boss_marker, 'click', function() {
    info_window.close();
    info_window.setContent("Your Location.");
    info_window.open(map, boss_marker);
  });
};

function add_person_icon_v3(info, map) {
  var image = '/images/pins/blue.png';
  var position = new google.maps.LatLng(info.lat, info.lng);
  var person_marker = new google.maps.Marker({
      position: position,
      map: map,
      icon: image
  });
};