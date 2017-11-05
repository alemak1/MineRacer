//
//  PlaneViewController.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import QuartzCore
import SceneKit


class PlaneViewController: UIViewController{
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    
    
    var gameHelper = GameHelper.sharedInstance
    
    var player: Plane!
    var worldNode: SCNNode!
  
    var followPortraitCameraNode: SCNNode!
    var followLandscapeCameraNode: SCNNode!
    
    var portraitCamera: SCNNode!
    var landscapeCamera: SCNNode!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadScene()
        
        setupView()
        
        setupNodes()
        
        setupGestureRecognizers()
        
        changePointOfView(to: .Portrait)
        
        gameHelper.state = .Playing
        
        //let ringNode = RingGenerator.GenerateRingNode(ofLetterType: .letter_A, ofLetterStyle: .Blue, ringRadius: 6.0, pipeRadius: 2.0)
        
       // scnScene.rootNode.addChildNode(ringNode)
        
       // ringNode.position = SCNVector3(player.node.position.x, player.node.position.y, player.node.position.z - 10)
    }
    
    func loadScene(){
       scnScene = SCNScene(named: "art.scnassets/scenes/Level3.scn")
    }
    
    func setupView(){
        scnView = view as! SCNView
        
        scnView.delegate = self
        
        scnView.scene = scnScene
        
        scnView.allowsCameraControl = false
        

        
    }
    
    func setupGestureRecognizers(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self.player, action: #selector(Plane.handleGesture(_:)))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeUp.direction = .up
        scnView.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeDown.direction = .down
        scnView.addGestureRecognizer(swipeDown)
        
        
    }

   
    
    
    func setupNodes(){
        
        print("Binding to references nodes...")
        
        // carNode = scene.rootNode.childNode(withName: "carFormula", recursively: true)!
        
        let planeReferenceNode = scnScene.rootNode.childNode(withName: "biplane_blue", recursively: true)!
        
        player = Plane(withReferenceNode: planeReferenceNode)
        
        followPortraitCameraNode = scnScene.rootNode.childNode(withName: "followPortraitCamera", recursively: true)!
        followLandscapeCameraNode = scnScene.rootNode.childNode(withName: "followLandscapeCamera", recursively: true)!
        
        worldNode = SCNNode()
        scnScene.rootNode.addChildNode(worldNode)
        
        let cube = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 0.0)
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cubeNode.physicsBody?.isAffectedByGravity = false
        /**
        cubeNode.physicsBody?.friction = 0.00
        cubeNode.physicsBody?.rollingFriction = 0.00
        cubeNode.physicsBody?.damping = 0.00
        cubeNode.physicsBody?.allowsResting = false
        **/
        
        worldNode.addChildNode(cubeNode)
        cubeNode.position  = SCNVector3(0.0, 3.0, -20.0)
        //cubeNode.physicsBody?.velocity =  SCNVector3(0.0, 0.0, 1.0)
    
       
    }
    
    /** Bind the camera nodes from the SCNScene file to references in code **/
    
    func setupCameras(){
        
        
        portraitCamera = scnScene.rootNode.childNode(withName: "portraitCamera", recursively: true)!
        landscapeCamera = scnScene.rootNode.childNode(withName: "landscapeCamera", recursively: true)!
 
     
        
        /**
         let lookAtCarConstraint = SCNLookAtConstraint(target: self.carNode)
         lookAtCarConstraint.isGimbalLockEnabled = true
         
         birdsEyeCamera.constraints = [lookAtCarConstraint]
         sideViewCamera.constraints = [lookAtCarConstraint]
         portraitCamera.constraints = [lookAtCarConstraint]
         landscapeCamera.constraints = [lookAtCarConstraint]
         firstPersonCamera.constraints = [lookAtCarConstraint]
         **/
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if let node = hitResults.first?.node{
            
            if(gameHelper.state == .Playing){
                
                
                if(node.name == "biplane_blue"){
                    print("Touched the plane, will jjump button")
                }
            }
    
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            changePointOfView(to: .Portrait)
            break
        case .landscapeLeft,.landscapeRight:
            changePointOfView(to: .Landscape)
            break
        default:
            break
        }
    }

    //TODO: add HUD to the camera node to keep it in position
    
    func changePointOfView(to pointOfView: PointOfView){
        
        switch pointOfView {
        case .SideView:
            break
        case .BirdsEye:
            break
        case .Landscape:
            scnView.pointOfView = self.landscapeCamera
            break
        case .Portrait:
            scnView.pointOfView = self.portraitCamera
            break
        case .FirstPerson:
            break
            
        }
    }
    
    
    func updateCameraPositions(){
        
        followPortraitCameraNode.position = player.node.presentation.position
        followLandscapeCameraNode.position = player.node.presentation.position
        
    }
    
}

extension PlaneViewController: SCNSceneRendererDelegate{
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        print("Updating game objects...")
        
        if(gameHelper.state == .Playing){
            
            print("About to propel the plane forward...")
            
            player.propelForward()
            
            updateCameraPositions()

        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    }
    
    
}
