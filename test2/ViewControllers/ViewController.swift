//
//  ViewController.swift
//  test2
//
//  Created by amirhosseinpy on 5/5/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var configuration : ARWorldTrackingConfiguration?
    var carpetNode: SCNNode?
    var anchors = [ARAnchor]()
    var isAdded = false
    var lightNodes = [SCNNode]()
    var lastYAxis: CGFloat = 0
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeSceneView()
//        initializeMenuButtonStatus()
        self.loadNodeObject()
        self.startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseSession()
    }
    
    func initializeSceneView() {
        // Set the view's delegate
        self.sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = false
        
        // Create new scene and attach the scene to the sceneView
        self.sceneView.scene = SCNScene()
        
        self.sceneView.autoenablesDefaultLighting = false
        
        self.sceneView.debugOptions  = [ARSCNDebugOptions.showFeaturePoints]

        self.sceneView.automaticallyUpdatesLighting = true
    }
    
    func loadNodeObject() {
        // get access to scene from scene assets and parse for the lamp model
        let tempScene = SCNScene(named: "art.scnassets/carpet/carpet.dae")!
        self.carpetNode = tempScene.rootNode.childNodes[0]
        self.carpetNode?.rotation = SCNVector4Make(.pi / 2, 0, 0, 0)
        self.carpetNode?.childNodes[0].geometry?.firstMaterial?.lightingModel = .physicallyBased
        self.carpetNode?.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/carpet/carpet 1.jpg")
        
//        self.carpetNode?.addChildNode(getLightNode())
//        self.carpetNode?.eulerAngles = SCNVector3Make(-.pi/2, 0, 0)
        //        (withName: "carpet", recursively: true)!
    }
    
    func getLightNode(position: SCNVector3) -> SCNNode {
        let light = SCNLight()
        light.type = .omni
        light.intensity = 500
        light.temperature = 0
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = position
        
        return lightNode
    }
    
    func startSession() {
        self.configuration = ARWorldTrackingConfiguration()
        //currenly only planeDetection available is horizontal.
        self.configuration!.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        self.sceneView.session.run(self.configuration!, options: [ARSession.RunOptions.removeExistingAnchors, ARSession.RunOptions.resetTracking])
    }
    
    func pauseSession() {
        self.sceneView.session.pause()
    }
    
    func continueSession() {
        self.sceneView.session.run(self.configuration!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.sceneView)
        if !self.isAdded {
            self.addNodeAtLocation(location: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = self.carpetNode else {
            return
        }
        
        //1. Get The Current Touch Point
        guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
            //2. Get The Next Feature Point Etc
            let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
        
        //3. Convert To World Coordinates
        let worldTransform = hitTest.worldTransform
        
        //4. Set The New Position
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        //5. Apply To The Node
//        self.carpetNode?.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        if self.sceneView.scene.rootNode.childNodes.count > 3 {
            self.sceneView.scene.rootNode.childNodes[3].simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        }
    }
    
    func addNodeAtLocation(location: CGPoint) {
        let hitResults = self.sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            self.isAdded = true
            let result: ARHitTestResult = hitResults.first!
            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
            let newLampNode = self.carpetNode?.clone()
            if let newLampNode = newLampNode {
                newLampNode.position = newLocation
                self.sceneView.scene.rootNode.addChildNode(newLampNode)
                self.sceneView.debugOptions  = []
//                self.addLightNodeTo(newLampNode, position: newLocation)
            }
        }
    }
    
    func updateLightNodesLightEstimation() {
        DispatchQueue.main.async {
            guard let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate
                else { return }
            
            let ambientIntensity = lightEstimate.ambientIntensity
            let ambientColorTemperature = lightEstimate.ambientColorTemperature
            
            for lightNode in self.lightNodes {
                guard let light = lightNode.light else { continue }
                light.intensity = ambientIntensity
                light.temperature = ambientColorTemperature
            }
        }
    }
    
    func addLightNodeTo(_ node: SCNNode, position: SCNVector3) {
        let lightNode = getLightNode(position: position)
        node.addChildNode(lightNode)
        lightNodes.append(lightNode)
    }
    
    
    @IBAction func onChangeSlider(_ sender: UISlider) {
        var carpetNode: SCNNode = SCNNode()
        if self.sceneView.scene.rootNode.childNodes.count > 3 {
         carpetNode = self.sceneView.scene.rootNode.childNodes[3]
        } else {
            return
        }
        
        let yAxis = CGFloat(sender.value)
//        if self.lastYAxis > yAxis {
//            self.lastYAxis = 0.97 - yAxis
//        } else {
//            self.lastYAxis = yAxis
//        }
        
        print(lastYAxis)
        carpetNode.runAction(SCNAction.rotateTo(x: CGFloat(carpetNode.eulerAngles.x), y: yAxis, z: CGFloat(carpetNode.eulerAngles.z), duration: 0.2))
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.updateLightNodesLightEstimation()
    }
    
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
