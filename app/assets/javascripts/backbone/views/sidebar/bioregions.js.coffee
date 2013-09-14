class Youngagrarians.Views.Bioregions extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/bioregions"

  events:
    'change select#bioregions': 'changeBioregion'

  updateBioregions: (data) =>
    province = data.province

    if !_.isNull(province) and !_.isUndefined(province)
      selector = province.toLowerCase()
      bioregions = @bioregions[selector]

      @$el.find("optgroup").remove()

      if !_.isUndefined bioregions
        optgroup = $("<optgroup>")
          .attr( 'id', "bioregions-"+selector )
          .attr( 'label', province+" Bioregions" )
        _(bioregions).each (region,index) ->
          option = $("<option>")
            .attr( 'value', index )
            .text( region )
          optgroup.append option

      @$el.find("select#bioregions").append optgroup

  changeBioregion: (e) =>
    e.preventDefault()
    selectedBioregion = $(e.target).find(":selected")
    if selectedBioregion.val() == "-1"
      @app.vent.trigger "bioregion:change", null
    else
      @app.vent.trigger "bioregion:change", 
        country: @model.get('country')
        province: @model.get('province')
        bioregion: selectedBioregion.text()

