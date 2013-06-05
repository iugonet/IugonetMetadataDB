// ==================================================
// sample script for google maps on DSpace at IUGONET
// last update: 2011-03-02 18:01:48 daiki
// ==================================================

// load google maps api v3 (in page header)
document.write('<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>');
var map = null;

// eliminate DSpace original css conflicted to gmaps modules (-_-#)
document.write('<style type="text/css">div.map_canvas * {margin:0px; padding:0px;}</style>');

// css for gmaps area
document.write('<style type="text/css">'
//			   + ' div.map_canvas {width:320px; height:180px; border:solid 1px #393; padding:0px; margin:0px; display:block;}'
			   + ' a.map_button {margin:2px 5px; font-size:80%;}'
			   + ' </style>');



function load_gmaps(glat, glon, title)
{
	document.write('<a href="#" onclick="toggle_map_canvas();return false;"'
				   + ' id="map_button_1" class="map_button"'
				   + ' >[toggle map]</a>');	
	document.write('<div id="map_canvas_1" class="map_canvas"'
				   + ' style="width:320px; height:180px; border:solid 1px #393; padding:0px; margin:0px; display:block;"></div>');
	
	var flag = !(Element.getStyle('map_canvas_1', 'display') == 'none');
	set_map_button($('map_button_1'), flag);
	init_gmaps(glat, glon, title);
}


function load_gmaps_spatial_search()
{
	document.write('<a href="#" onclick="toggle_map_canvas_search();return false;"'
				   + ' id="map_button_1" class="map_button"'
				   + ' >[toggle map]</a>');	
	document.write('<div id="map_canvas_1" class="map_canvas"'
				   + ' style="width:320px; height:180px; border:solid 1px #393; padding:0px; margin:0px auto; display:none;"></div>');
	
	var flag = !(Element.getStyle('map_canvas_1', 'display') == 'none');
	set_map_button($('map_button_1'), flag);
    if (flag) { setup_search_map(); }
}


function setup_search_map()
{
	var glat = 35, glon = 135;
	var title = null;

    	init_gmaps(glat, glon, title, 2);
	google.maps.event.addListener(map, 'idle', function() {
								  var latlngbounds = map.getBounds();
								  var bounds_north = latlngbounds.getNorthEast().lat();
								  var bounds_east = latlngbounds.getNorthEast().lng();
								  var bounds_south = latlngbounds.getSouthWest().lat();
								  var bounds_west = latlngbounds.getSouthWest().lng();
							       if (bounds_north > 85) { bounds_north = 90; }
							       if (bounds_south < -85) { bounds_south = -90; }
	    if (bounds_west > bounds_east) { bounds_east = bounds_east + 360; }
	    var zl = map.getZoom(); //0-19
								  $('d_nlat').setValue(round_deg(zl,bounds_north));
								  $('d_slat').setValue(round_deg(zl,bounds_south));
								  $('d_elon').setValue(round_deg(zl,bounds_east));
								  $('d_wlon').setValue(round_deg(zl,bounds_west));
								  });

}


function round_deg(zoom,val)
{
    val_array = val.toString().split('.');
    if (val_array.length < 2) {return val_array[0];}

    val_array[1] = val_array[1].substring(0,(zoom+1)/2);

    if (val_array[1].length < 1) {return val_array[0];}
    return val_array[0] + '.' + val_array[1];
}



function init_gmaps(glat, glon, title, zoom)
{
	var latlng = new google.maps.LatLng(glat, glon);
	if (zoom == null) zoom = 4;
	if (map == null) {
		var myOptions = {
			zoom: zoom,
			center: latlng,
			disableDefaultUI: true,
			mapTypeId: google.maps.MapTypeId.HYBRID,
			mapTypeControl: true,
			mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
			navigationControl: true,
			navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
		};
		map = new google.maps.Map($('map_canvas_1'), myOptions);
	}
	
	if (title != null) {
		var marker = new google.maps.Marker({
											position: latlng, 
											map: map, 
											title: title
											}); 
	}
}


function toggle_map_canvas()
{
    var flag = (Element.getStyle('map_canvas_1', 'display') == 'none');
    Effect.toggle('map_canvas_1', 'blind',
		  {duration: 0.3,
		   afterFinish: function() {
		       set_map_button($('map_button_1'), flag);
		   }
		  } );
}


function toggle_map_canvas_search()
{
	var flag = (Element.getStyle('map_canvas_1', 'display') == 'none');
	Effect.toggle('map_canvas_1', 'blind',
		      {duration: 0.3,
		       afterFinish: function() { 
			   set_map_button($('map_button_1'), flag);
			   //========== if first time to open map
			   if (Element.empty($('map_canvas_1'))) {
			       if (Element.getStyle('map_canvas_1', 'display') != 'none') {
				   setup_search_map();
			       }
			   }
		       }
		      } );
}


function set_map_button(id, flag)
{
	id.innerHTML = flag ? '[close map]' : '[view map]';
}