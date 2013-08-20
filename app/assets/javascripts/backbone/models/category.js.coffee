class Youngagrarians.Models.Category extends Backbone.RelationalModel
  paramRoot: 'category'

  defaults:
    name: null

  relations: [
    type: 'HasMany'
    key: 'subcategory'
    relatedModel: 'Youngagrarians.Models.Subcategory'
    includeInJSON: [Backbone.Model.prototype.idAttribute, 'name']
    collectionType: 'Youngagrarians.Collections.SubcategoryCollection'
    reverseRelation:
      key: 'location'
      includeInJSON: '_id'
  ]

  isHidden: =>
    #warning: hack, attribute in model would be better
    return @get('name') == 'Web Resource'

  getIcon: =>
    return '/~youngagr/map/assets/map-icons/' + @get('name').toLowerCase().replace(' ', '-') + ".png"

Youngagrarians.Models.Category.setup()

class Youngagrarians.Collections.CategoriesCollection extends Backbone.Collection
  model: Youngagrarians.Models.Category
  url: '/~youngagr/map/categories'

  comparator: ( a, b ) =>
    aName = a.get('name')
    bName = b.get('name')
    if aName == bName
      return 0
    else if aName < bName
      return -1
    return 1
