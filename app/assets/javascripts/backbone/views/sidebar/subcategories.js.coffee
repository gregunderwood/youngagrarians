#= require ./subcategory-item
class Youngagrarians.Views.Subcategories extends Backbone.Marionette.CollectionView

  tagName: "ul"
  className: "subcategories"

  itemView: Youngagrarians.Views.SubcategoryItem

  initialize: (options) =>
    @app = options.app
  
  buildItemView: (item, view, options) =>
    options = _.extend { app: @app, model: item }, options
    new view options
     

  