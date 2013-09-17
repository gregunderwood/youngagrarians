#= require ./selected-category
class Youngagrarians.Views.SelectedCategories extends Backbone.Marionette.CollectionView
  tagName: "ul"
  className: "selected-categories"

  itemView: Youngagrarians.Views.SelectedCategory
  
  buildItemView: (item, view, options) =>
    options = _.extend { app: @app, model: item }, options
    new view options

  initialize: (options) =>
    @app = options.app
