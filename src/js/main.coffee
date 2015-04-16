sizzle = require 'sizzle'
slides = require('./slides.cson').slides
React = require('react')
Slide = require('./slide')
Notes = require('./notes')

window.React = React

Site = React.createClass
  displayName: 'Slides'
  getInitialState: () ->
    return {
      currentIndex: 0
      notes: ''
    }
  getSlideState: (index) ->
    if index > @state.currentIndex
      return 'next'
    else if index < @state.currentIndex
      return 'previous'
    else if index == @state.currentIndex
      return 'current'
  updateSlideIndex: (index) ->
    index = if index < 0 then 0 else index
    index = if index > slides.length - 1 then slides.length - 1 else index
    @setState({currentIndex:index})
  componentDidMount: ()->
    document.onkeydown = @keyHandler
  keyHandler: (e)->
    e = e || window.event
    if e.keyCode == 38
      @updateSlideIndex(@state.currentIndex - 1)
    if e.keyCode == 40
      @updateSlideIndex(@state.currentIndex + 1)
  render: ->
    <div className="slides">
      {<Slide key={index} img={slideItem.img} slideState={@getSlideState(index)}/> for slideItem, index in @props.slides}
      <Notes isOpen={false} notes={@state.notes}/>
    </div>

document.addEventListener "DOMContentLoaded", (event)->
  React.render(<Site slides={slides}/>, document.body);
