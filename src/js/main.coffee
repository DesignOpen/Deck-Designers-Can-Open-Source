sizzle = require 'sizzle'

document.addEventListener "DOMContentLoaded", (event)->

  @slidesContainer = sizzle('.slides')[0]
  @slidesArray = sizzle('.slide')
  @currentSlide = sizzle('.slide.current')
  @slideIndex = 0

  @setCurrentSlide = (index) =>
    index = if index < 0 then 0 else index
    index = if index > @slidesArray.length - 1 then @slidesArray.length - 1 else index
    for slide in @slidesArray
      slide.classList.remove 'current'
    @slidesArray[index].classList.add 'current'
    @currentSlide = @slidesArray[index]
    @slideIndex = index
    console.log(@slidesContainer)
    @slidesContainer.style.top = -100*index+"vh"

  if @currentSlide.length == 0
    @setCurrentSlide 0
  else
    @setCurrentSlide 0
    # @setCurrentSlide @currentSlide[0]

  console.log @currentSlide
  nextSlide = ()=>
    @setCurrentSlide(@slideIndex+1)
    console.log @slideIndex
  prevSlide = ()=>
    @setCurrentSlide(@slideIndex-1)
    console.log @slideIndex
  checkKey = (e)->
    e = e || window.event
    if e.keyCode == 38
      prevSlide()
    if e.keyCode == 40
      nextSlide()
  document.onkeydown = checkKey
