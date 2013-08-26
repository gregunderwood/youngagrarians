class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/result-item"
  tagName: "li"
  className: "result-item"

  category: null
  subcategory: null
  bioregion: null

  serializeData: =>
    data = @model.toJSON()
    data.img = @model.get('category').getIcon()
    data.locUrl = @model.locUrl()
    data

  initialize: (options) ->
    @app = options.app
    @app.vent.on 'category:change', @categoryChanged
    @app.vent.on 'subcategory:change', @subcategoryChanged
    #@app.vent.on 'bioregion:change', @bioregionChanged
    @model.on 'change', @changeShow, @

  onShow: (options) =>
    @$el.hide()

  categoryChanged: (cat) =>
    @category = cat
    @changeShow @model

  subcategoryChanged: (data) =>
    @category = data.cat
    @subcategory = data.subcat
    @changeShow @model

  bioregionChanged: (data) =>
    bio = @model.get("bioregion")
    match = data.match bio

    if bio.length > 0 and !_.isNull(match)
      @$el.show()
    else
      @$el.hide()

  changeShow: (model) =>
    if @model.get 'markerVisible'
      if $.goMap.isVisible @model
        @$el.show()
      else
        @$el.hide()

      if @model.show( @category )
        @$el.show()
    else
      @$el.hide()
