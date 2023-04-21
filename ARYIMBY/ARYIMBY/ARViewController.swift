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
    @IBOutlet var visibilitySwitch: UISwitch!
    
    var arObject: SCNNode!
    var showBenefits = false
    
    var lowSelected = false
    var medSelected = false
    var highSelected = false
    
    
//    var addAnchorButton: UIButton!
    var cameraControlEnabled = true
    
    
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
        
//        //find the anchor button
//        guard let addAnchorButton = self.view.viewWithTag(101) as? UIButton else {
//            return
//        }
//        self.addAnchorButton = addAnchorButton
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // enable camera control
        sceneView.allowsCameraControl = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/AR_Scene_LMH.scn")! //test the actual site scene
         
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let wait3s:SCNAction = SCNAction.wait(duration: 3)
        let runAfter:SCNAction = SCNAction.run { _ in
            
            self.addSceneContent()
            
        }
        
        
        let seq:SCNAction = SCNAction.sequence( [wait3s, runAfter ] )
        sceneView.scene.rootNode.runAction(seq)
        
        //control the visbility via the switch
        arObject = sceneView.scene.rootNode
        

        
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            
            //hide the benefits at first -
            if (node.name == "HD_Node") || (node.name == "MD_Node")
//                || (node.name == "LD_Benefits") || (node.name == "MD_Benefits") || (node.name == "HD_Benefits")
            {
                node.isHidden = true
            }
            
            
        }
        
        
        //add tap recognizer for user tapping
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @IBAction func visibilitySwitchChanged(_ sender: UISwitch){
        if sender.isOn {
            arObject.isHidden = false
        } else {
            arObject.isHidden = true
        }
    }
    
  
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        //guard let sceneView = sender.view as? ARSCNView
        let touchLocation = sender.location(in:sceneView)

        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty { //if hit result is not empty

            for hitResult in hitTestResult{

                //print(hitTestResult.node.name)
                if (hitResult.node == ball) {
                    print("tap detected")
                    //apply the tap as an impulse force to the ball
//                    ball.physicsBody?.applyForce(SCNVector3(0,150,500), asImpulse: true)
                    
                }

            }

        }
            
    }
    
    
    //create a function for the dynamics to delay a little bit
    func addSceneContent(){
//        //TBD: add the objects node to the scene and set its position
//        let BenefitsNode = self.sceneView.scene.rootNode.childNode(withName: "Benefits", recursively: false)
//
//        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
//
//        BenefitsNode?.position = SCNVector3(0,-100,-300)
//
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//
//            if (node.name == "Benefits") {
//                print("found the objects ball!")
//                ball = node //pass the node found to the ball SCNNode object
//
//                //physics property
//                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:ball,options:nil))
//                ball.physicsBody?.isAffectedByGravity = false
//                ball.physicsBody?.restitution = 1
//
//            }
//        }
        
        
        //LOW DENSITY: DUMMY NODE - bring the dummyNode here
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        
        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
        
//        dummyNode?.position = SCNVector3(-100,-100,-300) //original positions
        dummyNode?.position = SCNVector3(-100,-50,-200)
        
        
        //add animation
        // Find the node with the given name in the scene
        if let spinNode1 = sceneView.scene.rootNode.childNode(withName: "LD_ball", recursively: true) {
            // Create a spinning animation
            let boundingBox = spinNode1.boundingBox
            print("check ld ball bounding box:")
            print(boundingBox)
            let pivot = SCNMatrix4MakeTranslation(
                (boundingBox.min.x + boundingBox.max.x)/2,
                (boundingBox.min.y + boundingBox.max.y)/2,
                (boundingBox.min.z + boundingBox.max.z)/2
            )
            
            spinNode1.pivot = pivot
//            spinNode1.pivot = SCNMatrix4MakeTranslation(120, 22, 0)
            
            let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 4)
            let repeatRotation = SCNAction.repeatForever(rotation)
            
            // Apply the animation to the node
            spinNode1.runAction(repeatRotation)
        }
        
        
        
        //TBD - refer to all the staff in the scene
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//
//            if (node.name == "ball") {
//                print("found the ball!")
//                ball = node //pass the node found to the ball SCNNode object
//
//                //physics property
//                ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:ball,options:nil))
//                ball.physicsBody?.isAffectedByGravity = true
//                ball.physicsBody?.restitution = 1
//
//            } else if (node.name == "box") {
//                print("found the box!")
//                box = node
//                let boxGeometry = box.geometry
//                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
//                box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
//                box.physicsBody?.restitution = 1
//            }
//
//        }
        
        
        //TBD: variabale name duplication need to be fixed!!! do the same thing below for MD_Node and HD_Node!
        //MEDIUM DENSITY: ME_NODE
        let MD_Node = self.sceneView.scene.rootNode.childNode(withName: "MD_Node", recursively: false)
        
        MD_Node?.position = SCNVector3(-100,-50,-200)
        
        
        // Find the node with the given name in the scene
        if let spinNode2 = sceneView.scene.rootNode.childNode(withName: "MD_ball", recursively: true) {
            // Create a spinning animation
            let boundingBox = spinNode2.boundingBox
            print("check md ball bounding box:")
            print(boundingBox)
            let pivot = SCNMatrix4MakeTranslation(
                (boundingBox.min.x + boundingBox.max.x)/2,
                (boundingBox.min.y + boundingBox.max.y)/2,
                (boundingBox.min.z + boundingBox.max.z)/2
            )
            
            spinNode2.pivot = pivot
            //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera./
//            spinNode2.pivot = SCNMatrix4MakeTranslation(-15, 850, -550)
            
            
            let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 4)
            let repeatRotation = SCNAction.repeatForever(rotation)
            
            // Apply the animation to the node
            spinNode2.runAction(repeatRotation)
        }
        
        
//        //TBD - refer to all the staff in the scene
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in //this would not go into the grand child nodes!!!
//
//            if (node.name == "MD_ball") {
//                print("found the MD ball!")
//                MD_ball = node //pass the node found to the ball SCNNode object
//
//                //physics property
//                MD_ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:MD_ball,options:nil))
//                MD_ball.physicsBody?.isAffectedByGravity = true
//                MD_ball.physicsBody?.restitution = 1
//
//            } else if (node.name == "MD_box") {
//                print("found the MD box!")
//                MD_box = node
//                let boxGeometry = MD_box.geometry
//                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
//                MD_box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
//                MD_box.physicsBody?.restitution = 1
//            }
//
//        }
        
        
        //HIGH DENSITY: ME_NODE
        let HD_Node = self.sceneView.scene.rootNode.childNode(withName: "HD_Node", recursively: false)
        
        HD_Node?.position = SCNVector3(-100,-50,-200)
        
        // Find the node with the given name in the scene
        if let spinNode3 = sceneView.scene.rootNode.childNode(withName: "HD_ball", recursively: true) {
            // Create a spinning animation
            let boundingBox = spinNode3.boundingBox
            print("check hd ball bounding box:")
            print(boundingBox)
            let pivot = SCNMatrix4MakeTranslation(
                (boundingBox.min.x + boundingBox.max.x)/2,
                (boundingBox.min.y + boundingBox.max.y)/2,
                (boundingBox.min.z + boundingBox.max.z)/2
            )
            
            spinNode3.pivot = pivot // not sure
//            spinNode3.pivot = SCNMatrix4MakeTranslation(450, 1050, -850)
//            dummyNode?.position = SCNVector3(0,-100,-300)
            
            let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 4)
            let repeatRotation = SCNAction.repeatForever(rotation)
            
            // Apply the animation to the node
            spinNode3.runAction(repeatRotation)
        }
        
//        //TBD - refer to all the staff in the scene
//        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//
//            if (node.name == "HD_ball") {
//                print("found the HD ball!")
//                HD_ball = node //pass the node found to the ball SCNNode object
//
//                //physics property
//                HD_ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node:HD_ball,options:nil))
//                HD_ball.physicsBody?.isAffectedByGravity = true
//                HD_ball.physicsBody?.restitution = 1
//
//            } else if (node.name == "HD_box") {
//                print("found the HD box!")
//                HD_box = node
//                let boxGeometry = HD_box.geometry
//                let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options:nil)
//                HD_box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
//                HD_box.physicsBody?.restitution = 1
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
    @IBAction func showLDNode() {
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            // use if else to check for existing visibility
            if (node.name == "MD_Node") && (node.isHidden == false) {
                node.isHidden = true
                medSelected = false
            }
            
            if (node.name == "HD_Node") && (node.isHidden == false) {
                node.isHidden = true
                highSelected = false
            }
            
            else if (node.name == "DummyNode") && (node.isHidden == true) {
                node.isHidden = false
                lowSelected = true
            }
        }
    }
    
    @IBAction func showMDNode() {
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            // use if else to check for existing visibility of three nodes - still having issue!
            if (node.name == "DummyNode") && (node.isHidden == false) {
                node.isHidden = true
                lowSelected = false
            }
            
            if (node.name == "HD_Node") && (node.isHidden == false) {
                node.isHidden = true
                highSelected = false
            }
            
            else if (node.name == "MD_Node") && (node.isHidden == true) {
                node.isHidden = false
                medSelected = true
            }
            
        }
    }
    
    @IBAction func showHDNode() {
        
        //unhide certain AR objects based on node names
        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            
            if (node.name == "DummyNode") && (node.isHidden == false) {
                node.isHidden = true
                lowSelected = false
            }
            
            if (node.name == "MD_Node") && (node.isHidden == false) {
                node.isHidden = true
                medSelected = false
            }
            
            else if (node.name == "HD_Node") && (node.isHidden == true) {
                node.isHidden = false
                highSelected = true
            }
        }
    }
    
    
    
    func hideshowNodeWithName(_ name: String, parentNode: SCNNode) {
        parentNode.enumerateChildNodes { (node, _) in
            if node.name == name {
                if (node.isHidden == true) {
                    node.isHidden = false
                } else {
                    node.isHidden = true
                }
            }
        }
    }
    
    @IBAction func fixButtonTapped(_ sender: UIButton) {
        if cameraControlEnabled {
            // Disable camera control
            sceneView.pointOfView?.childNodes.forEach({ node in
                node.constraints = []
            })
            sceneView.allowsCameraControl = false
            cameraControlEnabled = false
        } else {
            // Enable camera control
            sceneView.allowsCameraControl = true
            cameraControlEnabled = true
        }
    }
    
    @IBAction func showBenefitsNode() {

        print("show benefits button touched")
        
        //04/17 - have to put the benefits nodes on the first child node level!
        
        if (lowSelected == true) {
            print("show - low is selected")
            //show/hide low benefits
            
//            230417: this approach also has issue...
//            let node = self.sceneView.scene.rootNode.childNode(withName: "LD_Benefits", recursively: false)!
//            if (node.isHidden == true) {
//                node.isHidden = false
//            } else {
//                node.isHidden = true
//            }
            
//            230417: this approach below still has issue!!!
//            let parentNode = self.sceneView.scene.rootNode
//            let nodeName = "LD_Benefits"
//            hideshowNodeWithName(nodeName, parentNode: parentNode)

        } else if (medSelected == true) {
            print("show - medium is selected")
            //show/hide med benefits
//            let node = self.sceneView.scene.rootNode.childNode(withName: "MD_Benefits", recursively: false)!
//            if (node.isHidden == true) {
//                node.isHidden = false
//            } else {
//                node.isHidden = true
//            }
            
//            let parentNode = self.sceneView.scene.rootNode
//            let nodeName = "MD_Benefits"
//            hideshowNodeWithName(nodeName, parentNode: parentNode)
            
        } else {
            print("show - high is selected")
            //show/hide high benefits
//            let node = self.sceneView.scene.rootNode.childNode(withName: "HD_Benefits", recursively: false)!
//            if (node.isHidden == true) {
//                node.isHidden = false
//            } else {
//                node.isHidden = true
//            }
//            let parentNode = self.sceneView.scene.rootNode
//            let nodeName = "HD_Benefits"
//            hideshowNodeWithName(nodeName, parentNode: parentNode)
            
        }
        
//        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
//            if (node.name == "Benefits") {
//                print("found objects node after button touched")
//                if (node.isHidden == true) {
//                    node.isHidden = false
//                } else {
//                    node.isHidden = true
//                }
//
//            }
        
        
        //FOLLOWING NOT WORKING: SHOW INDIVIDUAL BENEFITS VIA BUTTON AS OF 04/17
//        sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            
//            if (node.name == "LD_Benefits") {
//                print("found LD_benefits nodes after button touched")
//                if (node.isHidden == true) {
//                    print("show LDB now")
//                    node.isHidden = false
//                } else {
//                    node.isHidden = true
//                }
//            }
//
//            if (node.name == "MD_Benefits") {
//                print("found MD benefits nodes after button touched")
//                if (node.isHidden == true) {
//                    print("show MDB now")
//                    node.isHidden = false
//                } else {
//                    node.isHidden = true
//                }
//            }
//
//            if (node.name == "HD_Benefits") {
//                print("found HD benefits nodes after button touched")
//                if (node.isHidden == true) {
//                    print("show HDB now")
//                    node.isHidden = false
//                } else {
//                    node.isHidden = true
//                }
//            }
        //}
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        //show the AR tracking points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
        
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
