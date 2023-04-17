//
//  ARVideoViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/16/23.
//

import UIKit
import WebKit
import ARKit

class ARVideoViewController: UIViewController, ARSCNViewDelegate, WKUIDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var webView: WKWebView!
    
    var videoNode: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoNode = createVideoNode()
        
//        // delegate the web view
//        webView.uiDelegate = self
//
//        // Add the WKWebView to the view hierarchy
////        view.addSubview(webView)
//
//        // Load a URL in the web view
//        let url = URL(string: "https://www.youtube.com/embed/oR85FFoyCAo")
//        let request = URLRequest(url: url!)
//        webView.load(request)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        //show the AR tracking points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes]
        
        //specify vertical plane detection
        configuration.planeDetection = .vertical

        sceneView.session.run(configuration)
        
        sceneView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Check if the anchor is a plane
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        
        
        //position video node
        videoNode?.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        videoNode?.eulerAngles.x = -.pi/2
        
        // Create a plane node and add it to the scene
        let planeNode = SCNNode()
        planeNode.addChildNode(videoNode!)
        node.addChildNode(planeNode)
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        planeNode.scale = SCNVector3(width, 1, height)
        
//        let planeNode = createPlaneNode(anchor: planeAnchor)
//        node.addChildNode(planeNode)
//
//        // Create a video node and add it to the plane
//        let videoNode = createVideoNode(anchor: planeAnchor)
//        planeNode.addChildNode(videoNode)
    }
    
    func createVideoNode() -> SCNNode {
        // Create a web view and load the video URL
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 360, height: 250))
        let url = URL(string: "https://www.youtube.com/embed/oR85FFoyCAo")!
        let request = URLRequest(url: url)
        webView.load(request)
        
        let plane = SCNPlane(width: 1.0, height: 0.5625)
        plane.firstMaterial?.diffuse.contents = webView
        let planeNode = SCNNode(geometry: plane)
        
        return planeNode
    }
    
//    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
//        // Create a plane geometry and add it to a node
//        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
//        let planeNode = SCNNode(geometry: plane)
//
//        // Position the node
//        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//        return planeNode
//    }
    
//    func createVideoNode(anchor: ARPlaneAnchor) -> SCNNode {
//        // Create a video node and add it to a node
//        let videoScene = SKScene(size: CGSize(width: 360, height: 250))
//        videoScene.backgroundColor = .clear
//
//        let videoNode = SKVideoNode(url: webView.url!)
//        videoNode.size = CGSize(width: 360, height: 250)
//        videoNode.position = CGPoint(x: videoNode.size.width / 2, y: videoNode.size.height / 2)
//        videoNode.zRotation = CGFloat(Double.pi)
//        videoScene.addChild(videoNode)
//
//        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
//        plane.firstMaterial?.diffuse.contents = videoScene
//        let videoPlaneNode = SCNNode(geometry: plane)
//
//        // Position the node
//        videoPlaneNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
//
//        return videoPlaneNode
//    }
    
    

}
