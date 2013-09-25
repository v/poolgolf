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
goog.require 'game.Pocket'
goog.require 'game.Wall'

game.start = ()->
    game.width = 1024
    game.height = 768
    game.gravity = new goog.math.Vec2(0, 0)
    game.max_speed = 1000
    game.min_speed = 20

    game.ball_radius = 25
    game.ball_color = '#444'

    game.friction = 1.5

    game.wall_restitution = 0.8


    director = new lime.Director(document.body, game.width, game.height)
    scene = new lime.Scene()
    game.target = new lime.Layer().setPosition(512, 384)

    game.level = 1

    game.scoreLabel = new lime.Label().setText('Your Score: 0')
        .setFontFamily('Verdana')
        .setFontColor('#000')
        .setFontSize('20')
        .setPosition(350, 325)

    game.balls = []
    game.initLevel(game.level)
    game.turns = 0

    game.target.appendChild(game.scoreLabel)

    scene.appendChild(game.target)

    director.makeMobileWebAppCapable()
    director.replaceScene(scene)

    lime.scheduleManager.schedule(game.step, game)



game.initLevel = (level) ->
    game.target.removeAllChildren()
    game.target.appendChild(game.scoreLabel)

    game.board = new game.Board(level)
    game.turns = 0
    game.score = 0
    game.updateScore()

    game.cueball = game.board.cueball

    game.balls = [game.cueball]

    for ball in game.board.balls
        game.balls.push(ball)

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
            line.setRotation(180 - angle)

            game.target.appendChild(line)
        )
        e.swallow(['mouseup', 'touchend'], (f)->
            game.turns += 1
            game.updateScore()

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
    if game.balls.length <= 1
        console.log 'you win'
        game.level += 1
        game.initLevel(game.level)


    for ball in game.balls
        for other in game.balls
            if ball != other and ball.collidesBall(other)
                console.log 'balls collide'
                game.resolveCollision(ball, other)

game.updateScore = ()->
    game.scoreLabel.setText('Your Score: '+game.turns)

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
