import UIKit
import PlaygroundSupport

class PathAnimationTest {
    
    func start() {
        let duration = 3.0
        
        let square = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        square.backgroundColor = UIColor.white
        
        PlaygroundPage.current.liveView = square
        
        let view = UIView(frame: CGRect(x: 155, y: 70, width: 120, height: 160))
        view.backgroundColor = .red
        square.addSubview(view)
        
        let path = UIBezierPath()
        path.move(to: view.center)
        path.addQuadCurve(to: square.center, controlPoint: CGPoint(x: view.center.x-10, y: square.center.y+160))
        UIColor.red.set()
        path.stroke()
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.purple.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        square.layer.addSublayer(shape)
        
        let scaleX = square.frame.width / view.frame.width
        let scaleY = square.frame.height / view.frame.height
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        animator.addAnimations {
            //view.transform = CGAffineTransform(scaleX: scaleY, y: scaleY)
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
                let points = 100
                for i in 1...points {
                    let pos = Double(i)/Double(points)
                    let x = self.quadBezier(pos: pos,
                                            start: Double(view.center.x),
                                            con: Double(view.center.x-10),
                                            end: Double(square.center.x))
                    let y = self.quadBezier(pos: pos,
                                            start: Double(view.center.y),
                                            con: Double(square.center.y+160),
                                            end: Double(square.center.y))
                    
                    let duration = 1.0/Double(points)
                    let startTime = duration * Double(i)
                    print("Animate: \(Int(x)) : \(Int(y))")
                    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: duration) {
                        view.center = CGPoint(x: x, y: y)
                    }
                }
            })
        }
        
        let points = 100
        for i in 1...points {
            let pos = Double(i)/Double(points)
            let x = self.quadBezier(pos: pos,
                                    start: Double(view.center.x),
                                    con: Double(view.center.x-10),
                                    end: Double(square.center.x))
            let y = self.quadBezier(pos: pos,
                                    start: Double(view.center.y),
                                    con: Double(square.center.y+160),
                                    end: Double(square.center.y))
            
            let point = UIView(frame: CGRect(x: x, y: y, width: 2, height: 2))
            point.backgroundColor = .blue
            print("Point: \(Int(x)) : \(Int(y))")
            square.addSubview(point)
        }
        
        animator.startAnimation()
    }
    
    func quadBezier(pos: Double, start: Double, con: Double, end: Double) -> Double {
        let t_ = (1.0 - pos)
        let tt_ = t_ * t_
        let tt = pos * pos
        
        return Double(start * tt_) + Double(2.0 * con * t_ * pos) + Double(end * tt)
    }
    
}

let test = PathAnimationTest()
test.start()

//let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//pathAnimation.path = path.cgPath
//pathAnimation.fillMode = CAMediaTimingFillMode.forwards
//pathAnimation.calculationMode = CAAnimationCalculationMode.paced
//pathAnimation.duration = duration
//pathAnimation.isRemovedOnCompletion = false
//view.layer.add(pathAnimation, forKey: nil)
