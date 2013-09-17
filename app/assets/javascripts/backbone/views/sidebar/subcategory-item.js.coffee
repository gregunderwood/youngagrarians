class Youngagrarians.Views.SubcategoryItem extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/subcategory-item"
  tagName: "li"
    
  events:
    'click a.add-subcategory': 'addSubcategory'

  initialize: (options) =>
    @app = options.app
    
  addSubcategory: =>
    @app.vent.trigger "subcategory:add", @model
    