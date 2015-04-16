# @cjsx React.DOM

React = require('react')
classNames = require('classnames')

Slide = React.createClass
  displayName: 'Slide'
  render: ->
    classes = classNames(
      slide: true
      next: (this.props.slideState == 'next')
      previous: (this.props.slideState == 'previous')
      current: (this.props.slideState == 'current')
    )
    <div className={classes} style={backgroundImage: "url(img/"+this.props.img+")"}/>

module.exports = Slide

# React.renderComponent <Car seat="front, obvs" />,
#   document.getElementById 'container'
