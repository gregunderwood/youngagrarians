class Youngagrarians.Models.Location extends Backbone.RelationalModel
  paramRoot: 'location'
  url: '/~youngagr/map/locations'

  relations: [
    {
      type: 'HasOne'
      key: 'category'
      relatedModel: 'Youngagrarians.Models.Category'
      includeInJSON: Backbone.Model.prototype.idAttribute,
      collectionType: 'Youngagrarians.Collections.CategoriesCollection'
      reverseRelation:
        key: 'location'
        includeInJSON: '_id'
    }
  ]

  defaults:
    latitude: null
    longitude: null
    gmaps: null
    address: null
    name: null
    content: null
    markerVisible: false

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

  locUrl: =>
    base = $("#root_url").data('url') + "#" + '/locations/' + @id

  showAnyways: (category_id) =>
    cat = @get('category')
    show = cat.isHidden()
    type = @get('resource_type') == 'Web'
    cat = cat == category_id
    return show || type || cat

  show: ( category_id ) =>
    s = @showAnyways category_id
    @set markerVisible: s
    return s

Youngagrarians.Models.Location.setup()

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/~youngagr/map/locations'
  show: []

  country: null
  province: null
  bioregion: null
  category: null
  subcategory: null

  provinceShorthand:
    "Canada":
      "BC": "British Columbia"
      "AB": "Alberta"
      "SK": "Saskatchewan"
      "MB": "Manitoba"
      "ON": "Ontario"
      "QC": "Quebec"
      "NB": "New Brunswick"
      "NS": "Nova Scotia"
      "PEI": "Prince Edward Island"
      "NV": "Nunavut"
      "NT": "Northwest Territories"
      "YK": "Yukon"
      "NF": "Newfoundland"
    "USA":
      "OR": "Oregon"

  countryAlts:
    "Canada" : []
    "USA" : ["United States","US"]

  initialize: (options) ->
    @direct = false
    @on 'map:update', @mapUpdate, @

  comparator: ( a, b ) =>
    aName = a.get('name')
    bName = b.get('name')
    if aName == bName
      return 0
    else if aName < bName
      return -1
    return 1

  setShow: (ids) =>
    @show = ids
    @mapUpdate
      type: 'update'

  clearShow: () =>
    @show = []
    @mapUpdate
      type: 'update'

  isEmpty: (val) =>
    provinceSelected = $("select#provinces").prop 'selectedIndex'
    bioregionSelected = $("select#bioregions").prop 'selectedIndex'
    categorySelected = $("select#category").prop 'selectedIndex'

    if provinceSelected > 0 or bioregionSelected > 0 or categorySelected > 0
      return _.isUndefined(val) || _.isNull(val)
    return false

  mapUpdate: (data) =>
    ids = $.goMap.markers
    markers = $.goMap.getMarkers()

    if !_.isUndefined(data.data) and !_.isNull(data.data)
      @country = data.data.country
      @bioregion = data.data.bioregion
      @category = data.data.category
      @subcategory = data.data.subcategory
      @province = data.data.province

    if data.type == 'update' or data.type == 'zoom' or data.type == 'dragend'
      @each (m) =>

        if !_.isUndefined(m) and !_.isNull(m)
          goodToShow = true

          if !_.isNull @category
            locationCategory = m.get('category').id
            goodToShow = goodToShow && ( locationCategory == @category )

          if !_.isNull @subcategory
            locationSubcategories = _(m.get('subcategory')).pluck('id')
            goodToShow = goodToShow && ( _(locationSubcategories).indexOf( @subcategory ) >= 0 )

          locationAddress = m.get("address")
          if !_.isNull(@province) and !_.isUndefined(@province)
            shortMatch = locationAddress.match @province
            fullMatch = null
            if !_.isUndefined @provinceShorthand[ @country ]
              fullMatch = locationAddress.match @provinceShorthand[ @country ][ @province ]
            goodToShow = goodToShow && ( !_.isNull( shortMatch ) or !_.isNull(fullMatch) )
          else
            if !_.isNull( @country )
              countryMatch = !_.isNull locationAddress.match @country
              altMatch = false
              _( @countryAlts[ @country ] ).each (country ) =>
                if !_.isNull( locationAddress.match country )
                  altMatch = true

              goodToShow = goodToShow && ( countryMatch || altMatch )

          if !_.isNull @bioregion
            bio = m.get('bioregion')
            if !_.isNull( bio ) and bio != ''
              bio = m.get("bioregion").split('-')
            else
              bio = []
            matches = []
            _( bio ).each (part) =>
              temp = @bioregion.match part
              if !_.isNull temp and temp[0] != ""
                matches.push temp[0]

            if !_.isNull( bio ) and bio.length > 0 and matches.length > 0
              goodToShow = goodToShow && true
            else
              goodToShow = false

          if !_.isNull( @show ) and @show.length > 0
            provinceSelected = $("select#provinces").prop 'selectedIndex'
            bioregionSelected = $("select#bioregions").prop 'selectedIndex'
            categorySelected = $("select#category").prop 'selectedIndex'
            if provinceSelected > 0 or bioregionSelected > 0 or categorySelected > 0
              goodToShow = goodToShow && ( _(@show).indexOf(m.id) >= 0 )
            else
              goodToShow = ( _(@show).indexOf(m.id) >= 0 )

          if @isEmpty( @category )
            goodToShow = false

          if !_.isUndefined m.marker
            m.marker.setVisible goodToShow

          if m.showAnyways( @category )
            goodToShow = true #goodToShow && true

          #m.set markerVisible: goodToShow
          m.show @category
          return true

    ###
    if data.type == 'zoom' or data.type == 'dragend'
      @each (m) =>
        isVisible = m.get 'markerVisible'
        m.set 'markerVisible', ( isVisible && $.goMap.isVisible(m) )
    ###

    if data.type == 'show'
      $.goMap.setMap
        latitude: data.data.lat()
        longitude: data.data.lng()
        zoom: 10
      @direct = true

      _(markers).each (latlng, i) =>
        id = parseInt ids[i].replace("location-","")
        if id != data.data.get("id")
          $.goMap.showHideMarker ids[i], false
        else
          $.goMap.showHideMarker ids[i], true
        loc = @get(id)
        loc.set 'markerVisible', loc.marker.visible


    true
