goog.provide 'game'

goog.require 'lime.Director'
goog.require 'lime.Scene'
goog.require 'lime.Layer'
goog.require 'lime.Circle'
goog.require 'lime.Label'
goog.require 'lime.animation.Spawn'
goog.require 'lime.animation.FadeTo'
goog.require 'lime.animation.ScaleTo'
goog.require 'lime.animation.MoveTo'

goog.require 'game.Ball'
goog.require 'game.Board'
goog.require 'game.CueBall'
goog.require 'game.Wall'

game.start = ()->
    game.width = 1024
    game.height = 768
    game.gravity = new goog.math.Vec2(0, 0)
    game.max_speed = 1000
    game.min_speed = 20

    game.ball_radius = 25
    game.ball_color = '#444'

    game.wall_restitution = 0.9

    director = new lime.Director(document.body, game.width, game.height)
    scene = new lime.Scene()
    game.target = new lime.Layer().setPosition(512, 384)


    game.cueball = new game.CueBall([(512+256) / 2, 300], '#0c0')
    game.board = new game.Board()

    game.balls = [
        game.cueball,
        new game.Ball([100, 100]),
        new game.Ball([-100, 100]),
        new game.Ball([-400, -100]),
        new game.Ball([-400, 100]),
    ]

    game.num_turns = 0

    scene.appendChild(game.target)

    director.makeMobileWebAppCapable()
    director.replaceScene(scene)

    lime.scheduleManager.schedule(game.step, game)

    goog.events.listen(game.cueball.touchshape, ['mousedown', 'touchstart'], (e)->
        e.startDrag(true)
        game.cueball.shape.setFill('#c00')
        line = null
        e.swallow(['mousemove', 'touchmove'], (f)->
            game.target.removeChild(line)
            diff = goog.math.Coordinate.difference(e.screenPosition, f.screenPosition)
            dragVector = new goog.math.Vec2(diff.x, diff.y)
            dragVector.scale(100)

            start = game.cueball.position.clone()

            line = new lime.Sprite().setSize(dragVector.magnitude(), 3)
            line.setPosition(start.x, start.y)
            line.setFill('#aaa')

            angle = Math.atan2(dragVector.y, dragVector.x) * 180 / Math.PI
            console.log angle
            line.setRotation(180 - angle)

            game.target.appendChild(line)
        )
        e.swallow(['mouseup', 'touchend'], (f)->
            game.target.removeChild(line)
            diff = goog.math.Coordinate.difference(e.position, f.position)
            dragVector = new goog.math.Vec2(diff.x, diff.y)
            dragVector.scale(2)
            game.cueball.shape.setFill('#0c0')
            console.log(dragVector)
            game.cueball.applyForce(dragVector)
        )
    )

game.step = () ->
    for ball in game.balls
        for other in game.balls
            if ball != other and ball.collidesBall(other)
                game.resolveCollision(ball, other)

game.resolveCollision = (one, two) ->
    rv = new goog.math.Vec2(two.velocity.x - one.velocity.x, two.velocity.y - one.velocity.y)

    normal = new goog.math.Vec2(two.position.x - one.position.x, two.position.y - one.position.y)
    normal.normalize()

    velAlongNormal = goog.math.Vec2.dot(rv, normal)

    if velAlongNormal > 0
        return

    RESTITUTION = 0.7

    j = -(1 + RESTITUTION) * velAlongNormal

    MASS = 10

    j /= 2/MASS

    normal.scale(j)
    impulse = normal
    impulse.scale(1/MASS)

    one.velocity.subtract(impulse)
    two.velocity.add(impulse)
