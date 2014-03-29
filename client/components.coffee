App.EventItemComponent = Ember.Component.extend
  #setup some handlebars flags
  setup: (->
    @setProperties
      isTag:      @get('event.event_type')  is "tag"
      isJoinGame: @get('event.event_type')  is "join_game"
  ).on("init")
  

App.LineChartComponent = Ember.Component.extend
  draw: ->
    margin =
      top: 20
      right: 80
      bottom: 30
      left: 50

    width = 700 - margin.left - margin.right
    height = 300 - margin.top - margin.bottom
    parseDate = d3.time.format("%Y%m%d").parse
    x = d3.time.scale().range([
      0
      width
    ])
    y = d3.scale.linear().range([
      height
      0
    ])
    color = d3.scale.category10()
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")
    line = d3.svg.line().interpolate("basis").x((d) ->
      x d.date
    ).y((d) ->
      y d.temperature
    )
    svg = d3.select("#chart").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    d3.csv "/public/data.csv", (error, data) ->
      color.domain d3.keys(data[0]).filter((key) ->
        key isnt "date"
      )
      data.forEach (d) ->
        d.date = parseDate(d.date)
        return

      cities = color.domain().map((name) ->
        name: name
        values: data.map((d) ->
          date: d.date
          temperature: +d[name]
        )
      )
      x.domain d3.extent(data, (d) ->
        d.date
      )
      y.domain [
        d3.min(cities, (c) ->
          d3.min c.values, (v) ->
            v.temperature

        )
        d3.max(cities, (c) ->
          d3.max c.values, (v) ->
            v.temperature

        )
      ]
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
      svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text ""
      city = svg.selectAll(".city").data(cities).enter().append("g").attr("class", "city")
      city.append("path").attr("class", "line").attr("d", (d) ->
        line d.values
      ).style "stroke", (d) ->
        color d.name

      city.append("text").datum((d) ->
        name: d.name
        value: d.values[d.values.length - 1]
      ).attr("transform", (d) ->
        "translate(" + x(d.value.date) + "," + y(d.value.temperature) + ")"
      ).attr("x", 3).attr("dy", ".35em").text (d) ->
        d.name
  didInsertElement: ->
    @draw()
  
