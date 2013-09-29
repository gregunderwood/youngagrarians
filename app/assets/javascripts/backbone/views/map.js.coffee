class Youngagrarians.Views.Map extends Backbone.Marionette.CompositeView
  template: "backbone/templates/map"
  itemView: Youngagrarians.Views.MapMarker
  map: null

  collectionEvents:
    'reset' : 'addMarkers'

  initialize: (options) =>
    @app = options.app
    @collection.on 'reset', @updateMap

  updateMap: =>
    $.goMap.clearMarkers()
    markers = new Backbone.Collection()        
    @collection.each (location)=>
        markers.add new Youngagrarians.Views.MapMarker
          model: location
    if @collection.currentBioregion
      @map.setCenter new google.maps.LatLng(@collection.currentBioregion.center.latitude, @collection.currentBioregion.center.longitude)
      @map.setZoom @collection.currentBioregion.zoom      
    else if @collection.currentSubdivision
      bounds = new google.maps.LatLngBounds()
      bounds.extend new google.maps.LatLng(@collection.currentSubdivision.bounds.south, @collection.currentSubdivision.bounds.east)
      bounds.extend new google.maps.LatLng(@collection.currentSubdivision.bounds.north, @collection.currentSubdivision.bounds.west)
      @map.fitBounds(bounds)
    else
      bounds = new google.maps.LatLngBounds()
      @collection.each (location)=>
        if location.lat() and location.lng()
          coords = new google.maps.LatLng(location.lat(), location.lng())
          bounds.extend coords
      if markers.length > 0
        @map.fitBounds(bounds)
        @map.setZoom 10 if @map.getZoom() > 10
      else
        @map.fitBounds(Youngagrarians.Constants.DEFAULT_BOUNDS())

  addMarkers: (col) =>
    _.defer =>
      @children.each ( child ) =>
        marker = child.createMarker()

  onShow: () =>
    @show = []
    map_style = [{
      stylers: [
        { saturation: -100 }
        { lightness: 16 }
      ]
    },{
      featureType: "road.arterial"
      stylers: [
        { lightness: -6 }
      ]
    },{
      featureType: "road.local"
      elementType: "geometry.stroke"
      stylers: [
        { lightness: 15 }
      ]
    }]
    @map = $("#map").goMap
      latitude: 54.826008
      longitude: -125.200195
      zoom: 5
      maptype: 'ROADMAP'
      scrollwheel: false
    
    @map = $.goMap.getMap() 
    #@map.setOptions 
    #  styles: map_style
      
    $.goMap.createListener(
      'map'
      'zoom_changed'
      (event) =>
        data =
          province: @province
          category: @category
          subcategory: @subcategory
          bioregion: @bioregion
          event: event
        @collection.trigger 'map:update', {type: 'zoom', data: data}
        true
    )

    $.goMap.createListener(
      'map'
      'dragend'
      (event) =>
        data =
          province: @province
          category: @category
          subcategory: @subcategory
          bioregion: @bioregion
          event: event
        @collection.trigger 'map:update', {type: 'dragend', data: data }
        true
    )

    if @collection.length
      _(@children).each (child) ->
        marker = child.createMarker()
        marker.setVisible false
    true

