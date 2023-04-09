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

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //Switch is not the best UI to handle 3 overlapping models!
//    @IBOutlet var LDSwitch: UISwitch!
//    @IBOutlet var MDSwitch: UISwitch!
//    @IBOutlet var HDSwitch: UISwitch!
//
//
//    var LDObject: SCNNode!
//    var MDObject: SCNNode!
//    var HDObject: SCNNode!
    
    //declare scene node for the ball and box
    var ball = SCNNode()
    var box = SCNNode()
    
    var MD_ball = SCNNode()
    var MD_box = SCNNode()
    
    var HD_ball = SCNNode()
    var HD_box = SCNNode()
    
    //Main function to render AR objects
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // enable camera control
        sceneView.allowsCameraControl = true
        
        // Create a new scene
        
        let scene = SCNScene(named: "art.scnassets/AR_Scene_LMH.scn")! //test the actual site scene
        
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
        
//        //control the visbility via the switch
//        LDObject = sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: true)!
//        MDObject = sceneView.scene.rootNode.childNode(withName: "MD_Node", recursively: true)!
//        HDObject = sceneView.scene.rootNode.childNode(withName: "HD_Node", recursively: true)!
        
        //hide certain AR objects based on node names - this cannot be put before the addSceneContent() method!!
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "HD_Node") || (node.name == "MD_Node") {
                node.isHidden = true
            }
        }
        
        //add tap recognizer for user tapping
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
//    @IBAction func LDSwitchChanged(_ sender: UISwitch){
//        if sender.isOn {
//            LDObject.isHidden = false
//        } else {
//            LDObject.isHidden = true
//        }
//    }
//
//    @IBAction func MDSwitchChanged(_ sender: UISwitch){
//        if sender.isOn {
//            MDObject.isHidden = false
//        } else {
//            MDObject.isHidden = true
//        }
//    }
//
//    @IBAction func HDSwitchChanged(_ sender: UISwitch){
//        if sender.isOn {
//            HDObject.isHidden = false
//        } else {
//            HDObject.isHidden = true
//        }
//    }
    
    
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
        
        //LOW DENSITY: DUMMY NODE - bring the dummyNode here
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        
        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
        
        dummyNode?.position = SCNVector3(0,-100,-300)
        
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
        
        
        //TBD: variabale name duplication need to be fixed!!! do the same thing below for MD_Node and HD_Node!
        //MEDIUM DENSITY: ME_NODE
        let MD_Node = self.sceneView.scene.rootNode.childNode(withName: "MD_Node", recursively: false)
        
        MD_Node?.position = SCNVector3(0,-100,-300)
        
        //refer to all the staff in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
        
            if (node.name == "MD_ball") {
                print("found the MD ball!")
                MD_ball = node //pass the node found to the ball SCNNode object
                
                //physics property
                MD_ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:MD_ball,options:nil))
                MD_ball.physicsBody?.isAffectedByGravity = true
                MD_ball.physicsBody?.restitution = 1
                
            } else if (node.name == "MD_box") {
                print("found the MD box!")
                MD_box = node
                let boxGeometry = MD_box.geometry
                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
                MD_box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
                MD_box.physicsBody?.restitution = 1
            }
            
        }
        
        
        //HIGH DENSITY: ME_NODE
        let HD_Node = self.sceneView.scene.rootNode.childNode(withName: "HD_Node", recursively: false)
        
        HD_Node?.position = SCNVector3(0,-100,-300)
        
        //refer to all the staff in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
        
            if (node.name == "HD_ball") {
                print("found the HD ball!")
                HD_ball = node //pass the node found to the ball SCNNode object
                
                //physics property
                HD_ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:HD_ball,options:nil))
                HD_ball.physicsBody?.isAffectedByGravity = true
                HD_ball.physicsBody?.restitution = 1
                
            } else if (node.name == "HD_box") {
                print("found the HD box!")
                HD_box = node
                let boxGeometry = HD_box.geometry
                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
                HD_box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
                HD_box.physicsBody?.restitution = 1
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
    
    
    
    
    // Only for actual site AR: add visibility button actions
    @IBAction func showLDNode() {
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "MD_Node")||(node.name == "HD_Node") {
                node.isHidden = true
            }
            else if node.name == "DummyNode" {
                node.isHidden = false
            }
        }
    }
    
    @IBAction func showMDNode() {
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "DummyNode")||(node.name == "HD_Node") {
                node.isHidden = true
            }
            else if node.name == "MD_Node" {
                node.isHidden = false
            }
        }
    }
    
    @IBAction func showHDNode() {
        
//        print("hide LD button clicked!")
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "DummyNode")||(node.name == "MD_Node") {
                node.isHidden = true
            }
            else if node.name == "HD_Node" {
                node.isHidden = false
            }
        }
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
