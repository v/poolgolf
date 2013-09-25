goog.provide 'game.Pocket'

goog.require 'game'

class Pocket extends Wall
    color: '#0c0'
    constructor:(position, length, direction)->
        super(position, length, direction)


game.Pocket = Pocket
