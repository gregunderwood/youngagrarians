class Youngagrarians.Views.Bioregions extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/bioregions"
  events:
    'change select': 'changeBioregion'

  initialize: (options)=>
    @app = options.app

  updateBioregions: (options) =>
    @country = _.findWhere Youngagrarians.Constants.COUNTRIES, {code: options.country}
    @subdivision = _.findWhere @country.subdivisions, {code: options.subdivision}
    $select = @$('select')
    $select.empty()
    $select.append '<option value="-1">Pick A BioRegion</option>'
    _.each @subdivision.bioregions, (region)=>
      option = $("<option>").attr('value', region.name).text(region.name)
      $select.append(option)

  changeBioregion: =>
    @bioregion = @$('select').find(":selected").val()
    @bioregion = null if @bioregion == "-1"
    @app.vent.trigger "bioregion:change", 
      country: @country.code
      subdivision: @subdivision.code
      bioregion: @bioregion

