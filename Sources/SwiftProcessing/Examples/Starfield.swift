//
//  Starfield.swift
//  
//
//  Created by Vasilis Akoinoglou on 8/8/20.
//

import Foundation

fileprivate var speed: CGFloat!

public class StarfieldSketchView: SPSView {

    var stars: [Star]!

    public override func setup() {
        //size(600, 600)
        stars = (0..<800).map { _ in Star(width, height) }
    }

    public override func draw() {
        speed = map(mouseX, 0, width, 0, 50)

        background(0)

        translate(width/2, height/2)

        for star in stars {
            star.update()
            star.show()
        }
    }

}

class Star {
    var x, y, z, pz: CGFloat
    var width: CGFloat
    var height: CGFloat

    init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
        // I place values in the variables
        x = random(-width/2, width/2)
        // note: height and width are the same: the canvas is a square.
        y = random(-height/2, height/2)
        // note: the z value can't exceed the width/2 (and height/2) value,
        // beacuse I'll use "z" as divisor of the "x" and "y",
        // whose values are also between "0" and "width/2".
        z = random(width/2)
        // I set the previous position of "z" in the same position of "z",
        // which it's like to say that the stars are not moving during the first frame.
        pz = z
    }

    func update() {
        // In the formula to set the new stars coordinates
        // I'll divide a value for the "z" value and the outcome will be
        // the new x-coordinate and y-coordinate of the star.
        // Which means if I decrease the value of "z" (which is a divisor),
        // the outcome will be bigger.
        // Wich means the more the speed value is bigger, the more the "z" decrease,
        // and the more the x and y coordinates increase.
        // Note: the "z" value is the first value I updated for the new frame.
        z = z - speed
        // when the "z" value equals to 1, I'm sure the star have passed the
        // borders of the canvas( probably it's already far away from the borders),
        // so i can place it on more time in the canvas, with new x, y and z values.
        // Note: in this way I also avoid a potential division by 0.
        if z < 1 {
            z = width/2
            x = random(-width/2, width/2)
            y = random(-height/2, height/2)
            pz = z
        }
    }

    func show() {
        fill(255)
        noStroke()

        // with theese "map", I get the new star positions
        // the division x / z get a number between 0 and a very high number,
        // we map this number (proportionally to a range of 0 - 1), inside a range of 0 - width/2.
        // In this way we are sure the new coordinates "sx" and "sy" move faster at each frame
        // and which they finish their travel outside of the canvas (they finish when "z" is less than a).

        let sx = map(x / z, 0, 1, 0, width/2)
        let sy = map(y / z, 0, 1, 0, height/2)

        // I use the z value to increase the star size between a range from 0 to 16.
        let r = map(z, 0, width/2, 16, 0)
        ellipse(sx, sy, r, r)

        // Here i use the "pz" valute to get the previous position of the stars,
        // so I can draw a line from the previous position to the new (current) one.
        let px = map(x / pz, 0, 1, 0, width/2)
        let py = map(y / pz, 0, 1, 0, height/2)

        // Placing here this line of code, I'm sure the "pz" value are updated after the
        // coordinates are already calculated; in this way the "pz" value is always equals
        // to the "z" value of the previous frame.
        pz = z

        stroke(255)
        line(px, py, sx, sy)
    }
}
