# @cjsx React.DOM

React = require('react')
classNames = require('classnames')

Notes = React.createClass
  displayName: 'Notes'
  render: ->
    classes = classNames(
      notes: true
      open: this.props.isOpen
    )
    <div className={classes} dangerouslySetInnerHTML={{__html:@props.notes}}/>

module.exports = Notes
