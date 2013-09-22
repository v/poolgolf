goog.provide 'game.Ball'

goog.require 'lime'
goog.require 'lime.Circle'
goog.require 'lime.Sprite'
goog.require 'game'

class Ball extends lime.Sprite
    constructor: (position, color)->
        @position = new goog.math.Vec2(position[0], position[1])
        @velocity = new goog.math.Vec2(0, 0)
        @radius = game.ball_radius
        @shape = new lime.Circle()
            .setSize(@radius * 2, @radius * 2)
            .setPosition(@position.x, @position.y)
        if !color
            color = game.ball_color

        @shape.setFill(color)

        @next_collision = 0

        lime.scheduleManager.schedule(@step_, @)
        game.target.appendChild(@shape)

    collidesBall: (other)->
        mine = @position.clone()
        theirs = other.position.clone()

        mine.subtract(theirs)

        return mine.magnitude() <= @radius * 2

    step_:(dt)->
        # step the position
        dist = @velocity.clone().scale(dt/1000)
        @position.add(dist)

        # step the velocity
        dvel = game.gravity.clone().scale(dt/1000)
        @velocity.add(dvel)

        # set the new position
        @shape.setPosition(@position.x, @position.y)

        if @velocity.magnitude() > game.max_speed
            @velocity.normalize().scale(game.max_speed)

        if @velocity.magnitude() < game.min_speed
            @velocity.x = 0
            @velocity.y = 0

        @velocity.scale(0.995)

        # collision with walls
        for wall in game.board.walls
            if @next_collision == 0 and wall.collidesCircle(@position, @radius)
                # DIRT DIRTY HACKS
                @next_collision = 4
                if wall.direction == 'x'
                    @velocity.y *= -game.wall_restitution
                if wall.direction == 'y'
                    @velocity.x *= -game.wall_restitution
                console.log wall.layer.getPosition().toString()

        # collision with other balls.
        if @next_collision > 0
            @next_collision -= 1

        return @

    applyForce:(vec)->
        vec.scale(3)
        @velocity.add(vec)


game.Ball = Ball
