//
//  ViewController.swift
//  flappy2
//
//  Created by Harley Trung on 3/12/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()

    var gravity: UIGravityBehavior!
    var push: UIPushBehavior!
    var birdProperties: UIDynamicItemBehavior!
    var pipeProperties: UIDynamicItemBehavior!
    var pipePush: UIPushBehavior!
    var collision: UICollisionBehavior!
    
    var isPlaying = false
    var birdOrigin: CGPoint!

    var timer: NSTimer!
    
    @IBAction func onPlayTapped(sender: UIButton) {
        if isPlaying {
            print("STOPPING")
            sender.setTitle("Play", forState: .Normal)
            isPlaying = false
            birdView.frame.origin = birdOrigin
            animator.removeAllBehaviors()
            timer.invalidate()
        } else {
            print("PLAYING")
            sender.setTitle("Stop", forState: .Normal)
            isPlaying = true
            setupBehaviors()
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.onTimer), userInfo: nil, repeats: true)

        }
    }
    
    @IBOutlet weak var birdView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // store bird position
        birdOrigin = birdView.frame.origin
        
        gravity = UIGravityBehavior(items: [birdView])
        push = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        push.active = false
        push.pushDirection = CGVectorMake(0, -1.1)
        
        birdProperties = UIDynamicItemBehavior(items: [birdView])
        birdProperties.allowsRotation = false
        
        pipePush = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Continuous)
        pipePush.active = true
        pipePush.pushDirection = CGVectorMake(-50.0, 0)
        
        collision = UICollisionBehavior(items: [birdView])

        pipeProperties = UIDynamicItemBehavior()
        pipeProperties.density = 100
        pipeProperties.resistance = 0
        drawPipes()
    }
    
    @IBAction func onScreenTap(sender: UITapGestureRecognizer) {
        print("tapping on screen")
        if isPlaying {
            let currentVelocity = birdProperties.linearVelocityForItem(birdView)
            // print("current velocity", currentVelocity)
            birdProperties.addLinearVelocity(CGPoint(x: currentVelocity.x, y: -currentVelocity.y), forItem: birdView)
            push.active = true
            animator.addBehavior(push)
        }
    }
    
    func drawPipes(onScreen:Bool = true) {
        let SCREEN_HEIGHT = Int(view.frame.height)
        let SCREEN_WIDTH  = Int(view.frame.width)
        let FULL_PIPE_HEIGHT = 320
        let FULL_PIPE_WIDTH  = 40
        let offsetX = onScreen ? (SCREEN_WIDTH - 40) : SCREEN_WIDTH

        let topPipe = UIImageView(image: UIImage(named: "pipeTop")!)
        // starting y is between -200 to -120, so that the visible pipe is 120 to 200 long
        topPipe.frame = CGRect(x: offsetX,
                               y: 0 - 120 - Int(arc4random_uniform(80)),
                               width: FULL_PIPE_WIDTH, height: FULL_PIPE_HEIGHT)
        setupPipe(topPipe)

        // offset starting y from the bottom
        let bottomPipe = UIImageView(image: UIImage(named: "pipeBottom")!)
        bottomPipe.frame = CGRect(x: offsetX,
                                  y: SCREEN_HEIGHT - 120 - Int(arc4random_uniform(80)),
                                  width: FULL_PIPE_WIDTH, height: FULL_PIPE_HEIGHT)
        setupPipe(bottomPipe)
    }
    
    func setupPipe(pipe: UIView) {
        view.addSubview(pipe)
        pipeProperties.addItem(pipe)
        pipePush.addItem(pipe)
        collision.addItem(pipe)
    }
    
    func setupBehaviors() {
        // we will add more behaviors soon
        animator.addBehavior(gravity)
        animator.addBehavior(birdProperties)
        animator.addBehavior(pipePush)
        animator.addBehavior(collision)
        animator.addBehavior(pipeProperties)
    }

    func onTimer() {
        drawPipes(false)
    }
}