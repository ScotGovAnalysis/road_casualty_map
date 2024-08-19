function(el, x, data) {
      function getColor(sev) {
      if (sev == 1) {
      return "red";
      } else if (sev == 2) {
       return "orange";
      } else {
      return "gray";
      }
      }
      
      function getIcon(input_type, sev){
      const iconType = {'Pedestrians': 
      L.AwesomeMarkers.icon({icon: 'android-walk', 
      prefix: 'ion', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      'Pedal cyclists':
      L.AwesomeMarkers.icon({icon: 'bicycle', 
      prefix: 'fa', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      'Motorcyclists':
      L.AwesomeMarkers.icon({icon: 'motorcycle', 
      prefix: 'fa', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      'Cars and taxis':
      L.AwesomeMarkers.icon({icon: 'car', 
      prefix: 'fa', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      'Bus, Coach, Minibus':
      L.AwesomeMarkers.icon({icon: 'bus', 
      prefix: 'fa', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      'LGV and HGV':
      L.AwesomeMarkers.icon({icon: 'truck', 
      prefix: 'fa', 
      markerColor: getColor(sev), 
      iconColor: 'black'}),
      };
      return iconType[input_type] || L.AwesomeMarkers.icon({
            icon: 'question',
            prefix: 'fa',
            markerColor: getColor(sev),
            iconColor: 'black'
        });  
      };
      var markers = L.markerClusterGroup(),
      group1 = L.featureGroup.subGroup(markers),
      group2 = L.featureGroup.subGroup(markers),
      group3 = L.featureGroup.subGroup(markers),
      group4 = L.featureGroup.subGroup(markers),
      group5 = L.featureGroup.subGroup(markers),
      group6 = L.featureGroup.subGroup(markers),
      group7 = L.featureGroup.subGroup(markers),
      control = L.control.layers(null, null, { collapsed: false }),
      i, a, title, marker;
      markers.addTo(this);
      for (var i = 0; i < data.longitude.length; i++) {
        marker = L.marker([data.latitude[i], data.longitude[i]], 
        {title: data.road_user[i], icon: getIcon(data.road_user[i], data.CASSEV[i])});
        marker.addTo(data.road_user[i] == 'Pedestrians' ? group1 : 
        data.road_user[i] == 'Pedal cyclists' ? group2 : 
        data.road_user[i] == 'Motorcyclists' ? group3 : 
        data.road_user[i] == 'Cars and taxis' ? group4 :
        data.road_user[i] == 'Bus, Coach, Minibus' ? group5 :
        data.road_user[i] == 'LGV and HGV' ? group6 :
        group7);
      }
      
    var control = L.control.layers(null, null, { collapsed: false });
    control.addOverlay(group1, 'Pedestrians');
    control.addOverlay(group2, 'Pedal Cyclists');
    control.addOverlay(group3, 'Motorcyclists');
    control.addOverlay(group4, 'Cars and taxis');
    control.addOverlay(group5, 'Bus, Coach, Minibus');
    control.addOverlay(group6, 'LGV and HGV');
    control.addOverlay(group7, 'Other');
    control.addTo(this);
    
    group1.addTo(this);
    group2.addTo(this);
    group3.addTo(this);
    group4.addTo(this);
    group5.addTo(this);
    group6.addTo(this);
    group7.addTo(this);
    }