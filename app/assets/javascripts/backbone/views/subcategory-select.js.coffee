class Youngagrarians.Views.SubcategorySelect extends Backbone.Marionette.ItemView
  
  template: 'backbone/templates/subcategory-select'

  events:
    'click a.remove-subcategory' : 'remove'

