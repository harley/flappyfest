//
//  ViewController.swift
//  flappy2
//
//  Created by Harley Trung on 3/12/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var push: UIPushBehavior!
    var birdProperties: UIDynamicItemBehavior!
    
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
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [birdView])
        push = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        push.active = false
        push.pushDirection = CGVectorMake(0, -1.1)
        
        birdProperties = UIDynamicItemBehavior(items: [birdView])
    }
    
    @IBAction func onScreenTap(sender: UITapGestureRecognizer) {
        print("tapping on screen")
        
        let currentVelocity = birdProperties.linearVelocityForItem(birdView)
        print("current velocity", currentVelocity)
        birdProperties.addLinearVelocity(CGPoint(x: currentVelocity.x, y: -currentVelocity.y), forItem: birdView)
        
        push.active = true
        animator.addBehavior(push)
    }
    
    func setupBehaviors() {
        // we will add more behaviors soon
        animator.addBehavior(gravity)
        animator.addBehavior(birdProperties)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}