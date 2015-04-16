sizzle = require 'sizzle'
slides = require('./slides.cson').slides
React = require('react')
Slide = require('./slide')
Notes = require('./notes')

window.React = React

Site = React.createClass
  displayName: 'Slides'
  getInitialState: () ->
    initialIndex = 0
    return {
      currentIndex: initialIndex
      notes: if(slides[initialIndex].notes)then slides[initialIndex].notes else ''
      notesOpen: false
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
    @setState({
      currentIndex:index
      notes:if(slides[index].notes)then slides[index].notes else ''
    })
  componentDidMount: ()->
    document.onkeydown = @keyHandler
  keyHandler: (e)->
    e = e || window.event
    switch e.keyCode
      when 38 then @updateSlideIndex(@state.currentIndex - 1)
      when 40 then @updateSlideIndex(@state.currentIndex + 1)
      when 78 then @setState({notesOpen: !@state.notesOpen})
  render: ->
    <div className="slides">
      {<Slide key={index} img={slideItem.img} slideState={@getSlideState(index)}/> for slideItem, index in @props.slides}
      <Notes isOpen={@state.notesOpen} notes={@state.notes}/>
    </div>

document.addEventListener "DOMContentLoaded", (event)->
  React.render(<Site slides={slides}/>, document.body);
