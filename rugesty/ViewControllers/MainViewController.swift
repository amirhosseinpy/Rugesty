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

class MainViewController: UIViewController, ARSCNViewDelegate {
//    @IBOutlet weak var listView: UIView!
//    @IBOutlet weak var listViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var labelHeightCons: NSLayoutConstraint!
    
//    var listView: UIView!
    var backgroundColoredView: UIView!
    var configuration : ARWorldTrackingConfiguration?
    var carpetNode: SCNNode?
    var anchors = [ARAnchor]()
    var lightNodes = [SCNNode]()
    var lastYAxis: CGFloat = 0
    var objectAnchor: ARAnchor?
    let updateQueue = DispatchQueue(label: "com.pooya.rugesty")
    var detectedPlanes: [String : SCNNode] = [:]
    
    var chosingMode: Bool = false {
        didSet {
            self.backgroundColoredView.isHidden = !self.chosingMode
        }
    }
    
    var isTrackingNormal = false {
        didSet {
            if !self.isTrackingNormal {
                self.trackingIsNotNormal()
            } else {
                self.trackingIsInNormalMode()
            }
        }
    }
    
    var isAdded = false {
        didSet {
            self.slider.isHidden = !self.isAdded
            self.guideLabel.isHidden = self.isAdded
        }
    }
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        self.initializeSceneView()
        Helper.setupImages()
        self.loadNodeObject()
        self.startSession()
        self.setupBackgroundView()
//        self.setupListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.continueSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.pauseSession()
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
    
//    func setupListView() {
//        self.listView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 340))
//        self.view.addSubview(self.listView)
////        self.listView.frame.origin.y = -340.0
//        let vc = getList()
//        addChildViewController(vc)
//        vc.view.frame = self.listView.bounds
//        self.listView.addSubview(vc.view)
//        vc.didMove(toParentViewController: self)
//        vc.delegate = self
//    }
    
    func setupBackgroundView() {
        self.backgroundColoredView = UIView(frame: self.view.bounds)
        self.view.addSubview(self.backgroundColoredView)
        self.backgroundColoredView.isHidden = true
        self.backgroundColoredView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTapped))
        self.backgroundColoredView.addGestureRecognizer(backgroundGesture)
        
        self.guideLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func getList() -> ListViewContrller {
        let story = UIStoryboard(name: "Main", bundle: self.nibBundle)
        return story.instantiateViewController(withIdentifier: "listViewController") as! ListViewContrller
    }
    
    func loadNodeObject() {
        // get access to scene from scene assets and parse for the lamp model
        let tempScene = SCNScene(named: "art.scnassets/carpet/carpet.dae")!
        self.carpetNode = tempScene.rootNode.childNodes[0]
//        self.carpetNode?.childNodes[0].scale = SCNVector3(0.67, 0.67, 0.67)
        self.carpetNode?.childNodes[0].scale = SCNVector3(1, 1, 1)
//        self.carpetNode?.simdScale = simd_float3(1, 1, 1)
        
        self.carpetNode?.rotation = SCNVector4Make(.pi / 2, 0, 0, 0)
        self.carpetNode?.childNodes[0].geometry?.firstMaterial?.lightingModel = .physicallyBased
        self.carpetNode?.childNodes[0].geometry?.firstMaterial?.diffuse.contents = Helper.images[Helper.selectedIndex]
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
        self.sceneView.debugOptions  = [.showFeaturePoints]
    }
    
    func pauseSession() {
        self.sceneView.session.pause()
    }
    
    func continueSession() {
        self.sceneView.session.run(self.configuration!)
    }
    
    func trackingIsInNormalMode() {
        if self.isAdded {
        self.guideLabel.isHidden = true
        } else {
            self.guideLabel.text = "flatten.rug".localized
            self.labelHeightCons.constant = "flatten.rug".localized.estimatedWidth(withConstrainedHeight: 25, font: UIFont.systemFont(ofSize: 15)) + 10
        }
        self.addButton.isHidden = false
    }
    
    func trackingIsNotNormal() {
        self.guideLabel.text = "walk.arround".localized
        self.labelHeightCons.constant = "walk.arround".localized.estimatedWidth(withConstrainedHeight: 25, font: UIFont.systemFont(ofSize: 15)) + 10
        self.guideLabel.isHidden = false
        self.addButton.isHidden = true
//        Helper.fadeViewInThenOut(view: self.guideLabel, delay: 0.5)
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
                updateQueue.async {
                    self.sceneView.scene.rootNode.addChildNode(newLampNode)
                    self.addOrUpdateAnchor(for: newLampNode)
                }
                self.sceneView.debugOptions  = []
//                self.addLightNodeTo(newLampNode, position: newLocation)
            }
        }
    }
    
    func addNodeAtLocation(location: SCNVector3) {
            let newLampNode = self.carpetNode?.clone()
            if let newLampNode = newLampNode {
                newLampNode.position = location
                switch Helper.selectedIndex {
                case 0:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(0.67, 0.67, 0.67)
                case 1:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(0.75, 0.75, 0.75)
                case 2:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(0.86, 0.86, 0.86)
                case 3:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(0.75, 0.75, 0.75)
                case 4:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(1.2, 1.2, 1.2)
                case 5:
                    newLampNode.childNodes[0].scale = SCNVector3(1, 1, 1)
//                    newLampNode.childNodes[0].scale = SCNVector3(0.67, 0.67, 0.67)
                default:
                    return
                }
                let yAxis = CGFloat(self.slider.value)
                newLampNode.runAction(SCNAction.rotateTo(x: CGFloat(newLampNode.eulerAngles.x), y: yAxis, z: CGFloat(newLampNode.eulerAngles.z), duration: 0.0))
                self.sceneView.scene.rootNode.addChildNode(newLampNode)
            }
    }
    
    func addOrUpdateAnchor(for object: SCNNode) {
        // If the anchor is not nil, remove it from the session.
        if let anchor = self.objectAnchor {
            self.sceneView.session.remove(anchor: anchor)
        }
        
        // Create a new anchor with the object's current transform and add it to the session
        let newAnchor = ARAnchor(transform: object.simdWorldTransform)
        self.objectAnchor = newAnchor
        self.sceneView.session.add(anchor: newAnchor)
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
    
    func onItemSelected() {
        self.carpetNode?.childNodes[0].geometry?.firstMaterial?.diffuse.contents = Helper.images[Helper.selectedIndex]
        
        if self.sceneView.scene.rootNode.childNodes.count > 3, self.isAdded {
            guard let lastNode = self.sceneView.scene.rootNode.childNodes.last else {
                return
            }
            
            let position = lastNode.position
            
            for _ in 4...self.sceneView.scene.rootNode.childNodes.count {
                self.sceneView.scene.rootNode.childNodes.last?.removeFromParentNode()
            }
            
            //            self.sceneView.scene.rootNode.childNodes[3].removeFromParentNode()
            self.addNodeAtLocation(location: position)
        }
    }
    
    //MARK: - Action
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
    
    @IBAction func onChangeSlider(_ sender: UISlider) {
        var carpetNode: SCNNode = SCNNode()
        if self.sceneView.scene.rootNode.childNodes.count > 3 {
         carpetNode = self.sceneView.scene.rootNode.childNodes[3]
        } else {
            return
        }
        
        let yAxis = CGFloat(sender.value)
        carpetNode.runAction(SCNAction.rotateTo(x: CGFloat(carpetNode.eulerAngles.x), y: yAxis, z: CGFloat(carpetNode.eulerAngles.z), duration: 0.2))
    }
    
    @IBAction func onNewProductTapped(_ sender: UIButton) {
        let vc = getList()
        vc.onItemSelected = {
            self.onItemSelected()
        }
        vc.present(to: self)
//        UIView.animate(withDuration: 0.7, animations: {
////            self.listView.frame.origin.y -= 340
//            self.chosingMode = true
//        })
    }
    
    @objc func onBackgroundTapped() {
        UIView.animate(withDuration: 0.7, animations: {
//            self.listView.frame.origin.y += 340
            self.chosingMode = false
        })
    }
    
    @objc func willResignActive(_ notification: Notification) {
        guard self.sceneView.scene.rootNode.childNodes.count > 3, self.isAdded else {
            return
        }
        
        guard let _ = self.sceneView.scene.rootNode.childNodes.last else {
            return
        }
        
        for _ in 4...self.sceneView.scene.rootNode.childNodes.count {
            self.sceneView.scene.rootNode.childNodes.last?.removeFromParentNode()
        }
        
        self.isAdded = false
        self.sceneView.debugOptions  = [ARSCNDebugOptions.showFeaturePoints]
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // 2
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x,
                                            planeAnchor.center.y,
                                            planeAnchor.center.z)
        // 3
        planeNode.opacity = 0.0
        // 4
        planeNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2.0)
        node.addChildNode(planeNode)
        // 5
        detectedPlanes[planeAnchor.identifier.uuidString] = planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // 2
        guard let planeNode = detectedPlanes[planeAnchor.identifier.uuidString] else { return }
        let planeGeometry = planeNode.geometry as! SCNPlane
        planeGeometry.width = CGFloat(planeAnchor.extent.x)
        planeGeometry.height = CGFloat(planeAnchor.extent.z)
        planeNode.position = SCNVector3Make(planeAnchor.center.x,
                                            planeAnchor.center.y,
                                            planeAnchor.center.z)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            self.isTrackingNormal = true
        default:
            self.isTrackingNormal = false
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}

extension MainViewController: ListViewContrllerDelegate {
    func itemDidChose() {
        self.onBackgroundTapped()
    }
}
