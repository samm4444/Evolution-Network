//
//  DisplayViewController.swift
//  Evolution Network
//
//  Created by Samuel Miller on 05/11/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class DisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "DisplayScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! DisplayScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    refreshScreen = {
                        sceneNode.displayBrain(brain: Global.data.brain)
                    }
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
            }
        }
    }
    
    var refreshScreen: (() -> (Void))?
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshScreen?()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
