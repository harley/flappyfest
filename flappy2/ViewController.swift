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
    var gravity = UIGravityBehavior()
    var isPlaying = false
    var birdOrigin: CGPoint!
    
    @IBAction func onPlayTapped(sender: UIButton) {
        if isPlaying {
            // STOP
            isPlaying = false
            birdView.frame.origin = birdOrigin
            animator.removeAllBehaviors()
        } else {
            // PLAY
            isPlaying = true
            // store bird position
            birdOrigin = birdView.frame.origin
            setupBehaviors()
        }
        print("play is tapped")
    }
    
    @IBOutlet weak var birdView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity.addItem(birdView)
    }
    
    func setupBehaviors() {
        animator.addBehavior(gravity)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

