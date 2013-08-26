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
      'cariboo-prince-george':
        zoomCenter: '52.816043,-121.179199'
        zoomLevel: 7
      'thompson-okanagan':
        zoomCenter: '50.625073,-118.520508'
        zoomLevel: 8
      'lower-mainland-southwest':
        zoomCenter: '49.239121,-122.629395'
        zoomLevel: 9
      'kootenays':
        zoomCenter: '49.582226,-116.608887'
        zoomLevel: 8

  collectionEvents:
    'reset' : 'addMarkers'
    'add'   : 'addMarker'

  initialize: (options) =>
    @app = options.app
    @app.vent.on 'bioregion:change', @bioRegionChanged
    @app.vent.on 'province:change', @provinceChanged
    @app.vent.on 'category:change', @categoryChanged
    @app.vent.on 'subcategory:change', @subcategoryChanged
    @app.vent.on 'search:started', @doSearch
    @app.vent.on 'search:clear', @clearSearch

  triggerCollectionUpdate: =>
    if not _.isUndefined( window.infoBubble ) and not _.isNull( window.infoBubble )
      window.infoBubble.close()

    data =
      country: @country
      province: @province
      category: @category
      subcategory: @subcategory
      bioregion: @bioregion
      event: 'update'
    @collection.trigger 'map:update', {type: 'update', data: data}
    @centerMap()

  categoryChanged: (category) =>
    @category = category
    @subcategory = null
    @triggerCollectionUpdate()

  subcategoryChanged: (data) =>
    @category = data.cat
    @subcategory = data.subcat
    @triggerCollectionUpdate()

  provinceChanged: (data) =>
    @country = data.country
    @province = data.province
    if !_.isNull( @province ) and !_.isUndefined( @province )
      @provinceSelector = @province.toLowerCase()
    else
      @provinceSelector = null
    @bioregion = null
    @triggerCollectionUpdate()

  bioRegionChanged: (bioregion) =>
    @bioregion = bioregion
    if !_.isNull( @bioregion ) and !_.isUndefined( @bioregion )
      @bioregionSelector = bioregion.toLowerCase().replace " ", "-"
    @triggerCollectionUpdate()

  addMarkers: (col) =>
    _.defer =>
      @children.each ( child ) =>
        marker = child.createMarker()

  addMarker: (model) =>
    @addMarkers model.collection

  clearSearch: (e) =>
    @collection.clearShow()

  searchSuccess: (data,status,xhr) =>
    ids = _(data).pluck 'id'
    locations = _(data).filter (v) ->
      v.address != ""

    locations = _(locations).pluck('id').map (id) ->
      'location-'+id

    showLocations = () =>
      if locations.length > 0
        $.goMap.fitBounds('markers', locations )
        if locations.length <= 1
          $.goMap.setMap
            zoom: 10
        @collection.setShow ids
      else
        @app.vent.trigger "search:nothing"
    _.delay showLocations, 100

  doSearch: (e) =>
    $.ajax
      type: "POST"
      url: "/~youngagr/map/search"
      data:
        terms: e
      success: @searchSuccess

  doSearchProvince: (e) =>
    e.preventDefault()
    console.log 'here'

    terms = $("#map-search-terms").val()
    province = $(e.target).data('province')

    $.ajax
      type: "POST"
      url: "/~youngagr/search"
      data:
        terms: terms
        province: province
      success: @searchSuccess

  centerMap: =>
    center = ''
    zoom = 5
    if !_.isNull( @province ) and !_.isNull( @country )
      center = @province + ", " + @country
    else if !_.isNull( @country )
      center = @country

    if !_.isNull( @bioregion )
      provinceSelector = @province.toLowerCase()
      bioregionSelector = @bioregion.toLowerCase().replace ' ', '-'
      console.log 'bioregion selector: ', bioregionSelector
      center = @bioregionAreas[ provinceSelector ][ bioregionSelector ][ 'zoomCenter' ]
      zoom = @bioregionAreas[ provinceSelector ][ bioregionSelector ][ 'zoomLevel' ]

    if center != ''
      $.goMap.setMap
        address: center
        zoom: zoom

  onShow: () =>
    @show = []
    @map = $("#map").goMap
      latitude: 54.826008
      longitude: -125.200195
      zoom: 5
      maptype: 'ROADMAP'
      scrollwheel: false

    @centerMap()

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

  filter: (data) =>
    data = _.extend { province: @province, category: @category, subcategory: @subcategory, bioregion: @bioregion }, data
    @collection.trigger 'map:update', {type: 'filter', data: data}
