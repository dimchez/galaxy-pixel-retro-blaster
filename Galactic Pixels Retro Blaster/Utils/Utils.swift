//
//  Utils.swift
//  Galactic Pixels Retro Blaster
//
//  Created by Dmitry Demyankov on 2023-11-15.
//

import SpriteKit


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func += (left: inout CGPoint, right: CGVector) {
    left.x += right.dx
    left.y += right.dy
}

func * (left: CGVector, right: CGFloat) -> CGVector {
    CGVector(dx: left.dx * right, dy: left.dy * right)
}

extension CGFloat {
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if (self > max) {
            return max
        } else if (self < min) {
            return min
        } else {
            return self
        }
    }
}

extension CGPoint {
    func distance(toPoint point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func isWithinDistance(_ threshold: CGFloat, ofPoint otherPoint: CGPoint) -> Bool {
        return self.distance(toPoint: otherPoint) < threshold
    }
}
