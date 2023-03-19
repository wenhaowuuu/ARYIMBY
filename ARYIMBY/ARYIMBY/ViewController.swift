//
//  ViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 3/10/23.
//

import UIKit
import SceneKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //declare scene node for the ball and box
    var ball = SCNNode()
    var box = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // enable camera control
        sceneView.allowsCameraControl = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ModelScene_LM_Compare.scn")!
//        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        //set the anchor
//        let anchor = AnchorEntity(plane: .horizontal)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let wait3s:SCNAction = SCNAction.wait(duration: 3)
        let runAfter:SCNAction = SCNAction.run { _ in
            
            self.addSceneContent()
            
        }
        
        let seq:SCNAction = SCNAction.sequence( [wait3s, runAfter ] )
        sceneView.scene.rootNode.runAction(seq)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        //guard let sceneView = sender.view as? ARSCNView
        let touchLocation = sender.location(in:sceneView)

        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty { //if hit result is not empty

            for hitResult in hitTestResult{

                //print(hitTestResult.node.name)
                if (hitResult.node == ball) {
                    //apply the tap as an impulse force to the ball
                    ball.physicsBody?.applyForce(SCNVector3(0,150,500), asImpulse: true)
                    
                }

            }

        }
            
    }
    
    
    //create a function for the dynamics to delay a little bit
    func addSceneContent(){
        
        //bring the dummyNode here
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        
        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
        
        //previous original position:
        //dummyNode?.position = SCNVector3(0,-200,-600) //all the children will be moved down to (0,-5,-5)
        dummyNode?.position = SCNVector3(0,-500,-700)
        
        //refer to all the staff in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
        
            if (node.name == "ball") {
                print("found the ball!")
                ball = node //pass the node found to the ball SCNNode object
                
                //physics property
                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:ball,options:nil))
                ball.physicsBody?.isAffectedByGravity = true
                ball.physicsBody?.restitution = 1
                
            } else if (node.name == "box") {
                print("found the box!")
                box = node
                let boxGeometry = box.geometry
                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
                box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
                box.physicsBody?.restitution = 1
            }
            
        }
        
        //add a light
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        self.sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        //show the AR tracking points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
        
        //specify horizontal plane detection
        configuration.planeDetection = .horizontal
        
        //adjust camera FOV?? not sure if this worked?
        if let camera = sceneView.pointOfView?.camera {
           camera.fieldOfView = 360
        }
        
        //add debug options
    
        // Run the view's session
        sceneView.session.run(configuration)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
