# @cjsx React.DOM

React = require('react')

Notes = React.createClass
  displayName: 'Notes'
  render: ->
    <div className="notes">{@props.notes}</div>

module.exports = Notes
