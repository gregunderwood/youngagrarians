class Youngagrarians.Views.Search extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/search"

  id: "search-form-container"
  className: "form-horizontal"

  events:
    'submit form#search-form':    'doMapSearch'
    'click button#search-button': 'doMapSearch'
    'click a#map-search-clear' :  'clearSearch'

  initialize: (options) =>
    @app = options.app

  doMapSearch: (e) =>
    e.preventDefault()
    term = @$el.find("input#search").val()
    if term == ''
      @$el.find("span.alert").slideDown()
      @$el.find("span.alert").slideUp()
    else
      @app.vent.trigger "search", 
        term: term

  clearSearch: (e) =>
    @$el.find("input#search").val ''
    @app.vent.trigger "search:clear"
