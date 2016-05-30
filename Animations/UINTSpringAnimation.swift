//
//  UINTSprintAnimation.swift
//  DemoAnimations
//
//  Created by wizard on 5/28/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
func CGPointSubtract(p1 : CGPoint, _ p2: CGPoint) -> CGPoint {
    return CGPointMake(p1.x - p2.x, p1.y - p2.y)
}

func CGPointAdd(p1 : CGPoint, _ p2: CGPoint) -> CGPoint {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y)
}

func CGPointMultiply(point :CGPoint, _ multiplier: CGFloat) -> CGPoint {
    return CGPointMake(point.x * multiplier, point.y * multiplier)
}

func CGPointLength(point: CGPoint) -> CGFloat {
    return CGFloat(sqrt(point.x * point.x + point.y * point.y))
}

class UINTSpringAnimation : NSObject, ArtificialAnimation {
    
    var velocity : CGPoint
    
    private var target : CGPoint
    private var view : UIView
    
    private let frictionConstant : CGFloat = 20
    private let springConstant : CGFloat = 300
    
    class func animationWithView(view: UIView, target: CGPoint, velocity:CGPoint) -> UINTSpringAnimation {
        return UINTSpringAnimation(view: view, target: target, velocity: velocity)
    }
    
    private init(view: UIView, target: CGPoint, velocity: CGPoint) {
        self.view = view
        self.target = target
        self.velocity = velocity
        
        super.init()
    }

    // ------------------------------
    //    首先让我们看一下我们需要知道的基础物理知识，这样我们才能实现出刚才使用 UIKit 力学实现的那种弹簧动画效果。为了简化问题，虽然引入第二个维度也是很直接的，但我们在这里只关注一维的情况 (在我们的例子中就是这样的情况)。
    //
    //    我们的目标是依据控制面板当前的位置和上一次动画后到现在为止经过的时间，来计算它的新位置。我们可以把它表示成这样：
    //
    //    y = y0 + Δy
    //    位置的偏移量可以通过速度和时间的函数来表达：
    //
    //    Δy = v ⋅ Δt
    //    这个速度可以通过前一次的速度加上速度偏移量算出来，这个速度偏移量是由力在 view 上的作用引起的。
    //
    //    v = v0 + Δv
    //    速度的变化可以通过作用在这个 view 上的冲量计算出来：
    //
    //    Δv = (F ⋅ Δt) / m
    //    现在，让我们看一下作用在这个界面上的力。为了得到弹簧效果，我们必须要将摩擦力和弹力结合起来：
    //
    //    F = F_spring + F_friction
    //    弹力的计算方法我们可以从任何一本教科书中得到 (编者注：简单的胡克定律)：
    //
    //    F_spring = k ⋅ x
    //    k 是弹簧的劲度系数，x 是 view 到目标结束位置的距离 (也就是弹簧的长度)。因此，我们可以把它写成这样：
    //
    //    F_spring = k ⋅ abs(y_target - y0)
    //    摩擦力和 view 的速度成正比：
    //
    //    F_friction = μ ⋅ v
    //    μ 是一个简单的摩擦系数。你可以通过别的方式来计算摩擦力，但是这个方法能很好地做出我们想要的动画效果。
    //
    //    将上面的表达式放在一起，我们就可以算出作用在界面上的力：
    //
    //    F = k ⋅ abs(y_target - y0) + μ ⋅ v
    //    为了实现起来更简单点些，我们将 view 的质量设为 1，这样我们就能计算在位置上的变化：
    //    
    //    Δy = (v0 + (k ⋅ abs(y_target - y0) + μ ⋅ v) ⋅ Δt) ⋅ Δt
    
    func animationTick(dt: CFTimeInterval, inout finished: Bool) {
        let time = CGFloat(dt)
        
        // friction force = velocity * friction constant
        let frictionForce = CGPointMultiply(velocity, frictionConstant);
        // spring force = (target point - current position) * spring constant
        let springForce = CGPointMultiply(CGPointSubtract(target, view.center), springConstant);
        // force = spring force - friction force
        let force = CGPointSubtract(springForce, frictionForce);
        // velocity = current velocity + force * time / mass
        velocity = CGPointAdd(velocity, CGPointMultiply(force, time));
        // position = current position + velocity * time
        view.center = CGPointAdd(view.center, CGPointMultiply(velocity, time));
        
        let speed = CGPointLength(velocity)
        let distanceToGoal = CGPointLength(CGPointSubtract(target, view.center))
        if (speed < 0.05 && distanceToGoal < 1) {
            view.center = target
            finished = true
        }
    }
}

