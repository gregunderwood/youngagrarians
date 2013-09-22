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

  lat: =>
    return @get 'latitude'

  lng: =>
    return @get 'longitude'

  locUrl: =>
    base = $("#root_url").data('url') + "#" + '/locations/' + @id

Youngagrarians.Models.Location.setup()

class Youngagrarians.Collections.LocationsCollection extends Backbone.Collection
  model: Youngagrarians.Models.Location
  url: '/~youngagr/map/locations'

  updateLocationsFromGoogleMaps: =>
    service = new google.maps.places.PlacesService($.goMap.getMap())
    @.each (loc)=>     
      return if loc.get('country_name') and loc.get('Location') == 'Location'
      request =
        location: new google.maps.LatLng(loc.lat(), loc.lng())
        radius: 20      
      service.nearbySearch request, (results, status)=>
        return unless results
        place = _.find results, (place)=>
          _.find place.types, (type)=>
            type == 'establishment'
        if place
          request = 
            reference: place.reference
          service.getDetails request, (result, status)=>
            return unless result
            city = _.find result.address_components, (ac)->
              ac = _.find ac.types, (type)->
                type == 'locality'
            province = _.find result.address_components, (ac)->
              ac = _.find ac.types, (type)->
                type == 'administrative_area_level_1'
            country = _.find result.address_components, (ac)->
              ac = _.find ac.types, (type)->
                type == 'country'
            loc.url = "/~youngagr/map/locations/#{loc.id}" 
            if province
              loc.set  
                province_name: province.long_name
                province_code: province.short_name                         
            loc.save
              city: city.long_name              
              country_name: country.long_name
              country_code: country.short_name

class Youngagrarians.Constants
  
  @COUNTRIES:[{
    name: "Canada"
    code: "CAN"
    subdivision_name: "Province"
    subdivisions: [{
      name: "British Columbia"
      code: "BC"
      bioregions:[{
        name: "Northeast"
      },{
        name: "Skeena-North Coast"
      },{
        name: "Vancouver Island-Coast"
      },{
        name: "Cariboo-Prince George"
      },{
        name: "Thompson-Okanagan"
      },{
        name: "Lower Mainland"
      },{
        name: "Lower Mainland-Southwest"
      },{
        name: "Kootenay"
      }]
    },{
      name: "Alberta"
      code: "AB"
      bioregions:[]
    },{
      name: "Saskatchewan"
      code: "SK"
      bioregions:[]
    },{
      name: "Manitoba"
      code: "MB"
      bioregions:[]
    },{
      name: "Ontario"
      code: "ON"
      bioregions:[]
    },{
      name: "Quebec"
      code: "QC"
      bioregions:[]
    },{
      name: "New Brunswick"
      code: "NB"
      bioregions:[]
    },{
      name: "Nova Scotia"
      code: "NS"
      bioregions:[]
    },{
      name: "Prince Edward Island"
      code: "PEI"
      bioregions:[]
    },{
      name: "Nunavut"
      code: "NV"
      bioregions:[]
    },{
      name: "Northwest Territories"
      code: "NT"
      bioregions:[]
    },{
      name: "Yukon"
      code: "YK"
      bioregions:[]
    },{
      name: "Newfoundland"
      code: "NF"
      bioregions:[]
    }]
  },{
    name: "United States"
    code: "USA"
    subdivision_name: "State"
    subdivisions: [{
      name: "Oregon"
      code: "OR"
      bioregions:[]
    }]
  }]       
           