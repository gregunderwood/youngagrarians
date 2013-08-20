class Youngagrarians.Views.Search extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/search"

  id: "search-form-container"
  className: "form-horizontal"

  events:
    'submit form#search-form': 'doMapSearch'
    'click button#start-search': 'doMapSearch'
    'click a#map-search-clear' : 'clearSearch'

  initialize: (options) =>
    @app = options.app
    @app.vent.on "search:nothing", @showNilResults

  showNilResults: (e) =>
    @$el.find("span.alert.nil").slideDown()
    slideUp = () =>
      @$el.find("span.alert.nil").slideUp()
    _.delay slideUp, 4000

  doMapSearch: (e) =>
    e.preventDefault()
    terms = @$el.find("input#search").val()
    $("select#provinces").prop 'selectedIndex', 0
    $("select#category").prop 'selectedIndex', 0
    $("select#bioregions").prop 'selectedIndex', 0
    if terms == ''
      @$el.find("span.alert.bad").slideDown()
      slideUp = () =>
        @$el.find("span.alert.bad").slideUp()
      _.delay slideUp, 4000
    else
      @app.vent.trigger "search:started", terms


  clearSearch: (e) =>
    @$el.find("input#search").val ''
    @app.vent.trigger "search:clear", ''
