<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html">
<html>
<head>
	<meta charset="utf-8">
	<title>Twitter Map</title>
	<script src="javascript/jquery-1.9.1.js"></script>
	<script type="text/javascript"
     src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKrR0xXhe195HxqHjxaYdtKeg4dEB1-LI&v=3.exp&sensor=false&libraries=visualization">
     </script>
	<style type="text/css">
     html, body, #map-canvas { height: 100%; margin: 0; padding: 0;}
   </style>
	<link rel="stylesheet" href="css/basic.css" type="text/css" media="screen" />
</head>
<body>
	<table border="1" class="center" align="center">
	 <tr>
	  <td>
	 	Live Streaming
	  </td>
	  <td>
	  	From Tweet Database
	  </td>
	 </tr>
	 <tr>
	  <td>
	    <button onclick="start()">Start Live Streaming</button>
	    <!--
	  	<form id="updateUsername1" name="updateUsername1" method="GET" action="TweetStream">
	  		<input type="submit" value="Start Live Streaming"/>
	  	</form>
	  	-->
	  	
	  </td>
	  <td>
	   <form id="updateUsername" name="updateUsername" method="POST" action="Tweet">
	    <table>
	     <tr>
		  <td>
		    Filter Key Word
	      </td>
		  <td>
		 	<select name="filterByKeyword">
				<option value="All">No Filter</option>
				<option value="Obama">Obama</option>
				<option value="Bieber">Bieber</option>
				<option value="America">America</option>
				<option value="India">India</option>
				<option value="Narendra Modi">Narendra Modi</option>
				<option value="Ebola">Ebola</option>
				<option value="Columbia" selected>Columbia</option>
				<option value="New York">New York</option>
			</select>
		  </td>
		  <td>
		  	Display Mode
		  </td>
		  <td>
			<select id="displayMode" name="displayMode">
				<option value="Heatmap" selected>Heatmap</option>
				<option value="Marker">Markers</option>
			</select>
		  </td>
		  <td>
		  	<input type="submit" value="Start Rendering"/>
		  </td>
		 </tr>
	  </table>
	</form>
	</td>
	</tr>
	</table>
	<div id="map-canvas"></div>
	<script type="text/javascript">
				
	    //Server Side Event Implementation of Live Streaming
		function start() {
			document.getElementById('map-canvas').innerHTML = "Loading Please wait...";
			var mapOptionsP = {
			         center: { lat: 40.8088, lng: -73.95},
			         zoom: 4
			};
			var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptionsP);
			var allMarkers = [];
			var eventSource = new EventSource("Tweet");
			for (var i = 0; i < allMarkers.length; i++) {
				allMarkers[i].setMap(null);
			}
			eventSource.addEventListener('message', function(event) {
				var resp = event.data;
				var respParts = resp.split('^');
				var id = respParts[0];
				var screenName = respParts[1];
				var latitude = respParts[2];
				var longitude = respParts[3];
				var content = respParts[4];
					
					var info_window = new google.maps.InfoWindow();
				    var marker_pos = new google.maps.LatLng(latitude, longitude);
				    marker = new google.maps.Marker({
				        position: marker_pos,
				        map: map,
				        title:content
				    });
				    allMarkers.push(marker);
				    google.maps.event.addListener(marker, 'click', function() {
				    	info_window.setContent('<b>'+screenName + "</b>");
				      	info_window.open(map, marker);
				     });
			});
		}
		
		function pausecomp(millis)
		 {
		  var date = new Date();
		  var curDate = null;
		  do { curDate = new Date(); }
		  while(curDate-date < millis);
		}
		
	    //Ajax Implementation of Live Streaming
		var frm1 = $('#updateUsername1');
 		frm1.submit(
 		  function() {
 			document.getElementById('map-canvas').innerHTML = "";
 			var mapOptionsP = {
			         center: { lat: 40.8088, lng: -73.95},
			         zoom: 4
			};
 			var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            for(var i=0; i<1000; i++) {
 			  //Start Ajax callback
			  $.ajax({
				url: frm.attr('action'),
				type: frm.attr('method'),
				data: $('#updateUsername1').serialize(),
				success: function(data) {
					var resp = event.data;
					var respParts = resp.split('^');
					var id = respParts[0];
					var screenName = respParts[1];
					var latitude = respParts[2];
					var longitude = respParts[3];
					var content = respParts[4];
					
					var info_window = new google.maps.InfoWindow();
				    var marker_pos = new google.maps.LatLng(latitude, longitude);
				    marker = new google.maps.Marker({
				        position: marker_pos,
				        map: map,
				        title:content
				    });
				    allMarkers.push(marker);
				    google.maps.event.addListener(marker, 'click', function() {
				    	info_window.setContent('<b>'+screenName + "</b>");
				      	info_window.open(map, marker);
				     });
				 }
			  });
			  return false;
			  //End Ajax Call back
			  pausecomp(1000);
            }
		});
 		
 		//For getting from Data base
		var frm = $('#updateUsername');
 		frm.submit(
 		  function() {
 			document.getElementById('map-canvas').innerHTML = "Loading Please wait...";
			$.ajax({
				url: frm.attr('action'),
				type: frm.attr('method'),
				dataType: 'json',
				data: $('#updateUsername').serialize(),
				success: function(data) {
					document.getElementById('map-canvas').innerHTML = "";
					var mapOptions = {
					         center: { lat: 40.8088, lng: -73.95},
					         zoom: 4
					       };
					var displayMode = document.getElementById("displayMode").value;
					var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
					var info_window = new google.maps.InfoWindow();
				    var markers = [];
				    var size = 0, key;
				    
				    for (key in data) {
				        if (data.hasOwnProperty(key)) size++;
				    }
				    if(displayMode == "Heatmap") {
				    
				    	for(i = 0; i < size; i++) {
			
				        	var marker_pos = new google.maps.LatLng(data[i].latitude, data[i].longitude);
				        	markers.push(marker_pos);
				    	}
				    	var pointArray = new google.maps.MVCArray(markers);

				    	var heatmap = new google.maps.visualization.HeatmapLayer({
				      	data: pointArray
				    	});
				    	heatmap.setMap(map);
				    }
				    else {
				    	for(i = 0; i < size; i++) {
							
				        	var marker_pos = new google.maps.LatLng(data[i].latitude, data[i].longitude);
				     
				        	marker = new google.maps.Marker({
				            	position: marker_pos,
				            	map: map,
				            	title:data[i].content
				        	});

				        	markers.push(marker);
				        	google.maps.event.addListener(marker, 'click', function() {
				        		info_window.setContent('<b>'+data[i].screenName + "</b>");
				        		info_window.open(map, marker);
				        	});
				    	}
				    }
				}
			});
			return false;
		});
 	</script>
</body>
</html>