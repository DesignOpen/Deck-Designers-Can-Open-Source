React = require('react')
slides = require('./slides.cson').slides
Primus = require('./primus.io.js')
Notes = require('./notes')

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
      notesOpen: true
    }
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
    socket.on 'slide', (msg)=>
      if(msg.id != @state.currentIndex)
        @updateSlideIndex(msg.id)
  render: ()->
    <div>
      <img src={"/img/"+@props.slides[@state.currentIndex].img}/>
      <Notes isOpen={@state.notesOpen} notes={@state.notes}/>
    </div>



document.addEventListener "DOMContentLoaded", (event)->
  React.render(<Site slides={slides}/>, document.body)
