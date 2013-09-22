goog.provide 'game.Board'

goog.require 'game.Wall'
goog.require 'lime.Sprite'

class Board extends lime.Sprite
    constructor: ()->
        @walls = []

        top = new game.Wall([-512, -384], 1024, 'x')
        down = new game.Wall([-512, 379], 1024, 'x')
        left = new game.Wall([-512, -384], 768, 'y')
        right = new game.Wall([507, -384], 768, 'y')

        @walls.push(top)
        @walls.push(down)
        @walls.push(left)
        @walls.push(right)

        @walls.push new game.Wall([-256, -384], 4*768/5.0, 'y')
        @walls.push new game.Wall([0, -384/4], 512, 'x')


game.Board = Board
