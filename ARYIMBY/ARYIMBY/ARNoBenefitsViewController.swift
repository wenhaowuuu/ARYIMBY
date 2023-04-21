//
//  ARNoBenefitsViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/19/23.
//

import UIKit
import SceneKit
import RealityKit
import ARKit


class ARNoBenefitsViewController: UIViewController, ARSCNViewDelegate {

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
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // enable camera control
        sceneView.allowsCameraControl = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/AR_Scene_LMH_NoBenefits.scn")! //test the actual site scene
         
        
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
        
        //LOW DENSITY: DUMMY NODE - bring the dummyNode here
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        
        //set the object child nodes' initial position (x,y,z). x:left or right of camera; y:up or down of camera; z: close or far of camera.
        
        dummyNode?.position = SCNVector3(-100,-50,-200) //work best if standing about 5 meters from a vertical wall. let the model's edge with ground align with the wall's ground line!
        

        //MEDIUM DENSITY: ME_NODE
        let MD_Node = self.sceneView.scene.rootNode.childNode(withName: "MD_Node", recursively: false)
        
        MD_Node?.position = SCNVector3(-100,-50,-200)
        
        
        
        //HIGH DENSITY: ME_NODEu
        let HD_Node = self.sceneView.scene.rootNode.childNode(withName: "HD_Node", recursively: false)
        
        HD_Node?.position = SCNVector3(-100,-50,-200)
        
        
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
