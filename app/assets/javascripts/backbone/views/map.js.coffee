class Youngagrarians.Views.Map extends Backbone.Marionette.CompositeView
  template: "backbone/templates/map"
  itemView: Youngagrarians.Views.MapMarker
  map: null

  country: null
  province: null
  provinceSelector: 'bc'
  bioregion: null
  bioregionSelector: null
  category: null
  subcategory: null

  bioregionAreas:
    'bc':
      'northeast':
        #where the map should center when this bioregion is chosen
        zoomCenter: '57.996455,-123.442383'
        #the outline of the shape for this bioregion
        zoomLevel: 6
      'skeena-north-coast':
        zoomCenter: '56.096556,-130.517578'
        zoomLevel: 6
      'vancouver-island-coast':
        zoomCenter: '49.75288,-126.079102'
        zoomLevel: 7
      'caribo-prince-george':
        zoomCenter: '52.816043,-121.179199'
        zoomLevel: 7
      'thompson-okanagan':
        zoomCenter: '50.625073,-118.520508'
        zoomLevel: 8
      'lower-mainland-southwest':
        zoomCenter: '49.239121,-122.629395'
        zoomLevel: 9
      'kootenay':
        zoomCenter: '49.582226,-116.608887'
        zoomLevel: 8

  collectionEvents:
    'reset' : 'addMarkers'

  initialize: (options) =>
    @app = options.app
    @collection.on 'reset', @updateMap

  updateMap: =>
    $.goMap.clearMarkers()
    markers = new Backbone.Collection()
    bounds = new google.maps.LatLngBounds()
    @collection.each (location)=>
      markers.add new Youngagrarians.Views.MapMarker
        model: location
      if location.lat() and location.lng()
        coords = new google.maps.LatLng(location.lat(), location.lng())
        bounds.extend coords    
    $.goMap.getMap().fitBounds(bounds) if markers.length > 0

  addMarkers: (col) =>
    _.defer =>
      @children.each ( child ) =>
        marker = child.createMarker()

  onShow: () =>
    @show = []
    @map = $("#map").goMap
      latitude: 54.826008
      longitude: -125.200195
      zoom: 5
      maptype: 'ROADMAP'
      scrollwheel: false

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

