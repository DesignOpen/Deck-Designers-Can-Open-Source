sizzle = require 'sizzle'
slides = require('./slides.cson').slides
React = require('react')
Slide = require('./slide')
Notes = require('./notes')
Primus = require('./primus.io.js')

window.React = React

socket = new Primus("ws://localhost:5000")
socket.on 'open', ()->
  console.log('opened')

Site = React.createClass
  displayName: 'Slides'
  getInitialState: () ->
    initialIndex = 0
    @sendSlide 0
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
  sendSlide: (index) ->
    sendSlide = @props.slides[index]
    sendSlide.id = index
    socket.send('slide', sendSlide)
  updateSlideIndex: (index) ->
    index = if index < 0 then 0 else index
    index = if index > slides.length - 1 then slides.length - 1 else index
    @setState({
      currentIndex:index
      notes:if(slides[index].notes)then slides[index].notes else ''
    })
    @sendSlide(index)
  componentDidMount: ()->
    document.onkeydown = @keyHandler
    socket.on 'slide', (msg)=>
      if(msg.id != @state.currentIndex)
        @updateSlideIndex(msg.id)
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
  React.render(<Site slides={slides}/>, document.body)


# socket.on('house', function(msg) {
#   var houses = msg;
#   for (var i = 0; i < houses.length; i++) {
#     var houseSelector = '[data-house-id='+ houses[i].id +']';
#     var houseElem = Sizzle(houseSelector);
#     Sizzle(houseSelector+' .housename')[0].innerHTML = houses[i].name;
#     Sizzle(houseSelector+' .housepoints')[0].innerHTML = houses[i].points;
#     var buttons = Sizzle(houseSelector+' button');
#     for(var j = 0; j < buttons.length; j++) {
#       buttons[j].disabled = false;
#     }
#   }
# }
