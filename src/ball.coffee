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

        @touchshape = new lime.Circle()
            .setSize(@radius * 4, @radius * 4)
            .setPosition(@position.x, @position.y)

        @next_collision = 0

        lime.scheduleManager.schedule(@step_, @)
        game.target.appendChild(@touchshape)
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
        @touchshape.setPosition(@position.x, @position.y)

        if @velocity.magnitude() > game.max_speed
            @velocity.normalize().scale(game.max_speed)

        # apply friction
        if @velocity.magnitude() > game.friction
            magnitude = @velocity.magnitude()
            new_magnitude = Math.max(magnitude - game.friction, 0)
            @velocity.normalize().scale(new_magnitude)
        else
            @velocity.scale(0)


        # collision with walls
        for wall in game.board.walls
            if @next_collision == 0 and wall.collidesCircle(@position, @radius)
                #collision with pockets.
                if wall in game.board.pockets and @ != game.cueball
                    index = game.balls.indexOf(@)
                    if index != -1
                        game.balls.splice(index, 1)

                        game.target.removeChild(@shape)

                    continue

                # DIRT DIRTY HACKS
                @next_collision = 4
                if wall.direction == 'x'
                    @velocity.y *= -game.wall_restitution
                if wall.direction == 'y'
                    @velocity.x *= -game.wall_restitution

        # collision with other balls.
        if @next_collision > 0
            @next_collision -= 1

        return @

    applyForce:(vec)->
        vec.scale(3)
        @velocity.add(vec)


game.Ball = Ball
