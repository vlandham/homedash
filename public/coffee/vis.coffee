
root = exports ? this

Plot = () ->
  width = 800
  height = 600
  data = []
  timezone = ""
  points = null
  margin = {top: 20, right: 20, bottom: 20, left: 20}
  xScale = d3.scale.linear().domain([0,10]).range([0,width])
  yScale = d3.scale.linear().domain([0,100]).range([height,0])
  xValue = (d) -> parseFloat(d.x)
  yValue = (d) -> parseFloat(d.y)

  xAxis = d3.svg.axis()
    .scale(xScale)
    .orient('bottom')

  prepareData = (data) ->
    timezone = data.timezone
    data = data.hourly.data
    data.forEach (d) ->
      d.time = moment(d.time).tz(timezone)
    data



  chart = (selection) ->
    selection.each (rawData) ->

      data = prepareData(rawData)
      console.log(data)

      svg = d3.select(this).selectAll("svg").data([data])
      gEnter = svg.enter().append("svg").append("g")
      
      svg.attr("width", width + margin.left + margin.right )
      svg.attr("height", height + margin.top + margin.bottom )

      g = svg.select("g")
        .attr("transform", "translate(#{margin.left},#{margin.top})")

      points = g.append("g").attr("id", "vis_points")
      update()

  update = () ->
    points.selectAll(".point")
      .data(data).enter()
      .append("circle")
      .attr("cx", (d) -> xScale(xValue(d)))
      .attr("cy", (d) -> yScale(yValue(d)))
      .attr("r", 4)
      .attr("fill", "steelblue")

  chart.height = (_) ->
    if !arguments.length
      return height
    height = _
    chart

  chart.width = (_) ->
    if !arguments.length
      return width
    width = _
    chart

  chart.margin = (_) ->
    if !arguments.length
      return margin
    margin = _
    chart

  chart.x = (_) ->
    if !arguments.length
      return xValue
    xValue = _
    chart

  chart.y = (_) ->
    if !arguments.length
      return yValue
    yValue = _
    chart

  return chart

root.Plot = Plot

root.plotData = (selector, data, plot) ->
  d3.select(selector)
    .datum(data)
    .call(plot)


$ ->

  plot = Plot()
  display = (error, data) ->
    plotData("#vis", data, plot)

  queue()
    .defer(d3.json, "/weather.json")
    .await(display)

