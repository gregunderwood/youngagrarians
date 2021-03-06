class Youngagrarians.Views.MapMarker extends Backbone.Marionette.ItemView
  template: "backbone/templates/map-marker"

  initialize: ->
    @marker = null

  createMarker: =>   
    data = @model.toJSON()
    data.link = encodeURIComponent @model.locUrl()

    category = @model.get('category').get('name')
    icon = @model.get('category').getMapIcon()

    data.category_name = category
    data.category_icon = icon

    subcategories = _( @model.get('subcategories') ).pluck('name').join(' , ')
    data.subcategories = subcategories

    lat = @model.get 'latitude'
    long = @model.get 'longitude'

    if !_.isUndefined( lat ) and !_.isNull( lat ) and !_.isUndefined( long ) and !_.isNull( long )
      @marker = $.goMap.createMarker
        latitude: @model.get 'latitude'
        longitude: @model.get 'longitude'
        id: 'location-' + @model.id
        group: category
        title: @model.get 'name'
        icon: icon

      @model.marker = @marker

      content = JST['backbone/templates/map-marker-bubble'](data)

      _model = @model
      _this = @
      
      
      $.goMap.createListener(
        { type: 'marker', marker: @marker.id },
        'click',
        () ->
          
          window.infoBubble.close() if not _.isUndefined(window.infoBubble) and not _.isNull(window.infoBubble)
          map = $.goMap.getMap()
          _infoBub = new InfoBubble
            disableAnimation: true
            maxWidth: YA.newMapWidth * 0.8
            maxHeight: 300
            arrowStyle: 2
            content: content
            backgroundClassName: 'map-bubble-background'
            borderRadius: 0
          _infoBub.open map, @
          
          google.maps.event.addListener _infoBub,'closeclick', =>
            map.setOptions
              zoomControl: true
              panControl: true
              mapTypeControl: true
          
          map.setOptions
            zoomControl:false
            panControl:false
            mapTypeControl: false
          window.infoBubble = _infoBub            
          
          func = () =>
            if !_.isUndefined window.twttr
              text = _model.get('name')
              twttr.widgets.createShareButton(
                _model.locUrl(),
                $("#map-popup-"+_model.id+" .share .twitter")[0],
                (el) =>
                { text: text, via: 'youngagrarians' }
              )

            facebookLink = $("#map-popup-"+_model.id+" .share .facebook a")

            facebookLink.on 'click', (e) ->
              e.preventDefault()
              img = $("#fb_img").data('img')
              data = {
                method: 'feed',
                link: _model.locUrl(),
                picture: img,
                name: "YoungAgrarians Map: " + _model.get('name'),
                caption: 'A location on the YoungAgrarians Resource Map'
                description: _model.get("description")
              }

              FB.ui data, (response) ->
                console.log 'response: ', response          
      )
    @marker

  getLocation: =>
    { lat: @model.get('latitude'), long: @model.get('longitude') }

  hideMarker: =>
    @marker.setVisible false

  showMarker: =>
    @marker.setVisible true

  onRender: () =>
    @$el.hide();
