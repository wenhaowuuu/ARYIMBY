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
    @IBOutlet var visibilitySwitch: UISwitch!
    
    
    var arObject: SCNNode!
    var LDHidden = false
    
    var showBenefits = false
    
    
    
    //declare scene node for the ball and box
    var ball = SCNNode()
    var box = SCNNode()
    var LD_Model = SCNNode()
    var LD_Benefits = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
//        // enable camera control
//        sceneView.allowsCameraControl = true
        
        // Create a new scene
        
        let scene = SCNScene(named: "art.scnassets/ModelScene_LMH_Compare.scn")! //updated VR educational scene
//        let scene = SCNScene(named: "art.scnassets/AR_Scene_LMH.scn")! //test the actual site scene
        
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
        
        //control the visbility via the switch
        arObject = sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: true)!
        
        //Use recursive function to hide the benefits node under dummyNode
        
        //hide certain AR objects based on node names - this cannot be put before the addSceneContent() method!!
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            //Note that The enumerateChildNodes(_:) function in the SceneKit framework enumerates all of the child nodes of a specified node, including its children, their children, and so on, in a depth-first search.
            
            //hide the benefits at first
            if (node.name == "Benefits") && (showBenefits == false) {
                node.isHidden = true
            }
        }
        
        
        //add tap recognizer for user tapping to release the dropping benefits objects
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //Not Sure about below code
//        //add tap recognizer for user tapping on the models to show the benefits 3D texts
//        let tapGestureBenefits = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.sceneView.addGestureRecognizer(tapGestureBenefits)
        
    }
    
    @IBAction func visibilitySwitchChanged(_ sender: UISwitch){
        if sender.isOn {
            arObject.isHidden = false
        } else {
            arObject.isHidden = true
        }
    }
    
    
//    @objc func handleTap(sender: UITapGestureRecognizer) {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        print("tapping detected")
        
        //230416 version - but not working yet
//        let sceneView = sender.view as! ARSCNView
//        let touchLocation = sender.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(touchLocation, options: [:])
//
//        guard let node = hitTestResults.first?.node else { return }
//
//        if node.name == "LD_Model"{
//            print("LD model tapped!")
//            if let hiddenNode = node.childNode(withName: "LD_Benefits", recursively: true) {
//                hiddenNode.isHidden = false
//            }
//        }
        
        
//        Old version: Define the ball dropping event below
//        guard let sceneView = sender.view as? ARSCNView // has error
                
        let touchLocation = sender.location(in:sceneView)

        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty {

            for hitResult in hitTestResult{

                //print(hitTestResult.node.name)
//                if (hitResult.node == LD_Model) {
//                    print("tapped LD model")
//                    LD_Benefits.isHidden = false
//                }
                
                if (hitResult.node == ball) {
                    //apply the tap as an impulse force to the ball
//                    ball.physicsBody?.applyForce(SCNVector3(0,150,500), asImpulse: true)

                }

            }

        }
        
        
            
    }
    
    
    
    
    //create a function for the dynamics to delay a little bit
    func addSceneContent(){
        
        //LOW DENSITY: DUMMY NODE - bring the dummyNode here
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        
        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
        
        //previous original position:
        //dummyNode?.position = SCNVector3(0,-200,-600) //all the children will be moved down to (0,-5,-5)
        dummyNode?.position = SCNVector3(0,-500,-700)
        
        //refer to all the staff in the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            
//            //pass the LD MD HD models and benefits nodes to variables
//            if (node.name == "LD_Model") {
//                print("found the LD model")
//                LD_Model = node
//                LD_Model.physicsBody?.isAffectedByGravity = false
//                LD_Model.physicsBody?.restitution = 1
//            }
//
//            if (node.name == "LD_Benefits") {
//                print("found the LD benefits")
//                LD_Benefits = node
//                LD_Benefits.physicsBody?.isAffectedByGravity = false
//                LD_Benefits.physicsBody?.restitution = 1
//
//            }
            
            //ball and box nodes
            if (node.name == "ball") {
                print("found the ball!")
                ball = node //pass the node found to the ball SCNNode object
                
                //physics property
                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:ball,options:nil))
                ball.physicsBody?.isAffectedByGravity = false
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
        
//
//        //HIGH DENSITY: ME_NODE
//        let HD_Node = self.sceneView.scene.rootNode.childNode(withName: "HD_Node", recursively: false)
//
//        HD_Node?.position = SCNVector3(0,-500,-700)
//
//        //refer to all the staff in the scene
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//
//            if (node.name == "HD_ball") {
//                print("found the HD ball!")
//                ball = node //pass the node found to the ball SCNNode object
//
//                //physics property
//                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:ball,options:nil))
//                ball.physicsBody?.isAffectedByGravity = true
//                ball.physicsBody?.restitution = 1
//
//            } else if (node.name == "HD_box") {
//                print("found the HD box!")
//                box = node
//                let boxGeometry = box.geometry
//                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
//                box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
//                box.physicsBody?.restitution = 1
//            }
//
//        }
        
        
        
        //add a light
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        self.sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    
    
    
    // Only for actual site AR: add visibility button actions
//    @IBAction func showGHGNode() {
//
//        //unhide certain AR objects based on node names
//        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
//            if (node.name != "GHG_Node") {
//                node.isHidden = true
//            }
//            else if node.name == "GHG_Node" {
//                node.isHidden = false
//            }
//        }
//    }
    
    
    @IBAction func showBenefitsNode() {
        
        print("show benefits button touched")
        
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if (node.name == "Benefits") {
                print("found benefits node after button touched")
                if (node.isHidden == true) {
                    node.isHidden = false
                } else {
                    node.isHidden = true
                }
                
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        //show the AR tracking points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
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
