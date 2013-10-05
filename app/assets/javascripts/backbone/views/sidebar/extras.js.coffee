class Youngagrarians.Views.Extras extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/extras"
  className: "extras"

  events:
    'click a#add-to-map': 'addLocation'
    'click a#show-about': 'showAbout'
    'click a#update-locations': 'updateLocations'

  initialize: (options) =>
    @app = options.app
    @categories = options.categories

  updateLocations: =>
    @app.vent.trigger 'update:locations'

  addLocation: (e) =>
    e.preventDefault()
    newLocation = new Youngagrarians.Models.Location
    addLoc = new Youngagrarians.Views.AddLocation 
      model: newLocation
      categories: @categories
    addLoc.render()

  showAbout: (e) =>
    e.preventDefault()
    about = new Youngagrarians.Views.About
    about.render()
