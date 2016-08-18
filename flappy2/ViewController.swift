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
    
    @IBAction func onPlayTapped(sender: UIButton) {
        if isPlaying {
            print("STOPPING")
            sender.setTitle("Play", forState: .Normal)
            isPlaying = false
            birdView.frame.origin = birdOrigin
            animator.removeAllBehaviors()
        } else {
            print("PLAYING")
            sender.setTitle("Stop", forState: .Normal)
            isPlaying = true
            setupBehaviors()
        }
    }
    
    @IBOutlet weak var birdView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        pipePush.pushDirection = CGVectorMake(-100.0, 0)
        
        collision = UICollisionBehavior(items: [birdView])

        pipeProperties = UIDynamicItemBehavior()
        pipeProperties.density = 100
        drawPipes()
    }
    
    @IBAction func onScreenTap(sender: UITapGestureRecognizer) {
        print("tapping on screen")
        
        let currentVelocity = birdProperties.linearVelocityForItem(birdView)
        // print("current velocity", currentVelocity)
        birdProperties.addLinearVelocity(CGPoint(x: currentVelocity.x, y: -currentVelocity.y), forItem: birdView)
        
        push.active = true
        animator.addBehavior(push)
    }
    
    func drawPipes() {
        let SCREEN_HEIGHT = Int(view.frame.height)
        let SCREEN_WIDTH  = Int(view.frame.width)
        let MAX_PIPE_HEIGHT = 200
        
        let bottomPipe = UIImageView(image: UIImage(named: "pipeBottom")!)
        bottomPipe.frame = CGRect(x: SCREEN_WIDTH - 40, y: SCREEN_HEIGHT - MAX_PIPE_HEIGHT, width: 40, height: 320)
        
        let topPipe = UIImageView(image: UIImage(named: "pipeTop")!)
        topPipe.frame = CGRect(x: SCREEN_WIDTH - 40, y: MAX_PIPE_HEIGHT - 320, width: 40, height: 320)
        
        setupPipe(bottomPipe)
        setupPipe(topPipe)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}