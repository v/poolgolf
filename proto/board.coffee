goog.provide 'game.Board'

goog.require 'game.Wall'
goog.require 'lime.Sprite'

class Board extends lime.Sprite
    constructor: (level)->
        @walls = []
        @pockets = []
        @balls = []

        if level == 1
            @level1()
        if level == 2
            @level2()
        if level == 3
            @level3()

    level1: ()->
        top = new game.Wall([-512, -180], 1024, 'x')
        down = new game.Wall([-512, 180], 1024, 'x')
        left = new game.Wall([-512, -180], 360, 'y')
        right = new game.Wall([507, -180], 360, 'y')

        @walls.push(top)
        @walls.push(down)
        @walls.push(left)
        @walls.push(right)

        @pockets = [
            new game.Pocket([400, -180], 360, 'y')
        ]

        for pocket in @pockets
            @walls.push pocket

        @balls = [
            new game.Ball([-200, -50]),
            new game.Ball([100, 100]),
        ]

        @cueball = new game.CueBall([-400, 0], '#0c0')


    level2: ()->
        top = new game.Wall([-512, -384], 1024, 'x')
        down = new game.Wall([-512, 379], 1024, 'x')
        left = new game.Wall([-512, -384], 768, 'y')
        right = new game.Wall([507, -384], 768, 'y')

        @walls.push(top)
        @walls.push(down)
        @walls.push(left)
        @walls.push(right)

        @walls.push(new game.Wall([0, -384], 384, 'y'))

        @pockets = [
            new game.Pocket([-512, -256], 128, 'x'),
            new game.Pocket([-512+128, -384], 134, 'y'),
            new game.Pocket([512-128, -256], 128, 'x'),
            new game.Pocket([512-128, -384], 134, 'y'),
        ]

        for pocket in @pockets
            @walls.push pocket

        @balls = [
            new game.Ball([-350, 0]),
            new game.Ball([-200, -200]),
            new game.Ball([350, 0]),
            new game.Ball([200, -200]),
        ]

        @cueball = new game.CueBall([0, 250], '#0c0')



    level3: ()->
        top = new game.Wall([-512, -384], 1024, 'x')
        down = new game.Wall([-512, 379], 1024, 'x')
        left = new game.Wall([-512, -384], 768, 'y')
        right = new game.Wall([507, -384], 768, 'y')

        @walls.push(top)
        @walls.push(down)
        @walls.push(left)
        @walls.push(right)

        @walls.push(new game.Wall([0, 0], 384, 'y'))
        @walls.push(new game.Wall([0, 0], 256, 'x'))

        @pockets = [
            new game.Pocket([-512, 256], 128, 'x'),
            new game.Pocket([-512+128, 256], 128, 'y'),
            new game.Pocket([512-128, 256], 128, 'x'),
            new game.Pocket([512-128, 384-128], 128, 'y'),
        ]

        for pocket in @pockets
            @walls.push pocket

        @balls = [
            new game.Ball([-200, 0]),
            new game.Ball([350, 150]),
            new game.Ball([200, -200]),
        ]

        @cueball = new game.CueBall([-350, -200], '#0c0')





game.Board = Board
