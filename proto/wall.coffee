goog.provide 'game.Wall'
goog.require 'lime.Sprite'

goog.require 'game'

class Wall
    constructor: (position, length, direction) ->
        THICKNESS = 6
        @layer = new lime.Layer().setPosition(position[0], position[1])
        @rect = new lime.Sprite().setAnchorPoint([1,1])
        @direction = direction
        if direction == 'x'
            @rect.setSize(length, THICKNESS)
        else if direction == 'y'
            @rect.setSize(THICKNESS, length)
        @rect.setFill('#000')
        @layer.appendChild(@rect)
        game.target.appendChild(@layer)

    collidesCircle: (pos, radius, velocity) ->
        center = @layer.getPosition().clone()
        size = @rect.getSize()

        width = size.width
        height = size.height

        center.x += width / 2
        center.y += height / 2

        xdist = Math.abs(center.x - pos.x)
        ydist = Math.abs(center.y - pos.y)

        distance = new goog.math.Vec2(xdist, ydist)

        if distance.x >= width / 2 + radius
            return false
        if distance.y >= height / 2 + radius
            return false

        if distance.x <= width / 2
            return true
        if distance.y <= height / 2
            return true

        cornersq = (distance.x - @rect.width / 2)^2 + (distance.y - @rect.height / 2)^2

        return cornersq <= radius * radius


game.Wall = Wall
