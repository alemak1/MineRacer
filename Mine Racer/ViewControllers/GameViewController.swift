//
//  GameViewController.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

   
    
    
    //MARK: ******** GameHelper singleton
    
    let gameHelper: GameHelper = GameHelper.sharedInstance
    
    //MARK: ********* Character Actions
    
    var turnLeftAction: SCNAction!
    var turnRightAction: SCNAction!
    
    
    var tiltRightAction: SCNAction!
    var tiltLeftAction: SCNAction!
    
    var carSpeed: Float = 0.00
    
    var carThrustVector: SCNVector3{
    
       //Need to determine the z and x components based on different euler angles
        
       //let pi = Float.pi

        //var yAngle = (carNode.presentation.eulerAngles.y + 2*pi).truncatingRemainder(dividingBy: 2*pi)
        
        let yAngle = carNode.presentation.eulerAngles.y
        
        var xComp: Float = 0.00
        var zComp: Float = 0.00
        
        let xConditionLeft = yAngle > 0
        let xConditionRight = yAngle < 0
        
        if(xConditionRight){
            xComp = cosf(yAngle)
            zComp = sin(yAngle)

        } else if (xConditionLeft){
            xComp = -cosf(yAngle)
            zComp = -sin(yAngle)
        }
     
        
        return SCNVector3(self.carSpeed*xComp, 0.0, self.carSpeed*zComp)
    }
    
    func setupActions(){
        
        let duration = 0.2
        
        turnLeftAction = SCNAction.rotateBy(x: 0.0, y: CGFloat.pi*2.0*(10.0/360.0), z: 0.00, duration: duration)
        turnRightAction = SCNAction.rotateBy(x: 0.0, y: CGFloat.pi*(-2.0)*(10.0/360.0), z: 0.00, duration: duration)

    }
    
    
    func moveCarForward(){
        
        let duration = 0.10
        let forwardVector = SCNVector3(0.0, 0.0, -1.0)
        carNode.runAction(SCNAction.move(by: forwardVector, duration: duration))    }
    
    func moveCarBackward(){
        let duration = 0.10
        let forwardVector = SCNVector3(0.0, 0.0, 1.0)
        carNode.runAction(SCNAction.move(by: forwardVector, duration: duration))
    }
    
    func turnCarLeft(){
        
        let yPresentationAngle = carNode.presentation.eulerAngles.y
        
        print("Turning car...presentation angle is : \(yPresentationAngle)")
        
        if(yPresentationAngle > Float.pi/2.0 || yPresentationAngle < -Float.pi/2.0){
            return
        }
        
        
        let torque = SCNVector4(0.0, 1.0, 0.0, 0.001)
        carNode.physicsBody?.applyTorque(torque, asImpulse: true)
    }
    

    
    func turnCarRight(){
    
        let yPresentationAngle = carNode.presentation.eulerAngles.y

        print("Turning car...presentation angle is : \(yPresentationAngle)")

        if(yPresentationAngle > Float.pi/2.0 || yPresentationAngle < -Float.pi/2.0){
            return
        }
        
        
        
        
        let torque = SCNVector4(0.0, 1.0, 0.0, -0.001)
        carNode.physicsBody?.applyTorque(torque, asImpulse: true)
    }
    
    
    func increaseSpeed(){
        print("increasing car speed...")
        carSpeed += 0.1
    }
    
    func decreaseSpeed(){
        print("decreasing car speed...")

        if(carNode.physicsBody!.velocity.z < Float(0.0)){
            return
        }
        
        carSpeed -= 0.1
    }
    
   
    
    func setupGestureRecognizers(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self.basicCharacter, action: #selector(BasicCharacter.handleGesture(_:)))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: basicCharacter, action: #selector(BasicCharacter.handleGesture(_:)))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp = UISwipeGestureRecognizer(target: basicCharacter, action: #selector(BasicCharacter.handleGesture(_:)))
        swipeUp.direction = .up
        scnView.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: basicCharacter, action: #selector(BasicCharacter.handleGesture(_:)))
        swipeDown.direction = .down
        scnView.addGestureRecognizer(swipeDown)
        
        
    }
    
    

    
   
    
    //TODO: add HUD to the camera node to keep it in position
    
    func changePointOfView(to pointOfView: PointOfView){
        
        switch pointOfView {
        case .SideView:
            scnView.pointOfView = self.sideViewCamera
            break
        case .BirdsEye:
            scnView.pointOfView = self.birdsEyeCamera
            break
        case .Landscape:
            scnView.pointOfView = self.landscapeCamera
            break
        case .Portrait:
            scnView.pointOfView = self.portraitCamera
            break
        case .FirstPerson:
            scnView.pointOfView = self.firstPersonCamera
            break
    
        }
    }
    
    var scnView: SCNView!
    var scene: SCNScene!
    
    var carNode: SCNNode!
    var basicCharacter: BasicCharacter!
    
    var followFirstPersonCameraNode: SCNNode!
    var followBirdsEyeCameraNode: SCNNode!
    var followSideViewCameraNode: SCNNode!
    var followPortraitCameraNode: SCNNode!
    var followLandscapeCameraNode: SCNNode!
    
    var birdsEyeCamera: SCNNode!
    var sideViewCamera: SCNNode!
    var portraitCamera: SCNNode!
    var landscapeCamera: SCNNode!
    var firstPersonCamera: SCNNode!
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupView()
        setupNodes()
        setupCameras()
        
        setupActions()
        setupGestureRecognizers()
        
        
        scnView.pointOfView = self.portraitCamera
        
        self.gameHelper.state = .Playing
        
        // add a tap gesture recognizer
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //  scnView.addGestureRecognizer(tapGesture)
    }
    
    
    func setupView(){
        
        print("Setting up the SCN scene view...")
        
        self.scnView = self.view as! SCNView
        
        //set the current view controller as the scene renderer delegeate
        scnView.delegate = self
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        

    }
    
    func setupScene(){
        print("Loading the scene...")
        scene = SCNScene(named: "art.scnassets/scenes/Level2.scn")!
    }
    
    func setupNodes(){
        
        print("Binding to references nodes...")

       // carNode = scene.rootNode.childNode(withName: "carFormula", recursively: true)!
        
        let characterReferenceNode = scene.rootNode.childNode(withName: "basicCharacter", recursively: true)!
        
        let collisionNode = scene.rootNode.childNode(withName: "Collision", recursively: true)!
        
        basicCharacter = BasicCharacter(withReferenceNode: characterReferenceNode, collisionReferenceNode: collisionNode)

        followFirstPersonCameraNode = scene.rootNode.childNode(withName: "FollowFirstPersonCameraNode", recursively: true)!
        followSideViewCameraNode = scene.rootNode.childNode(withName: "FollowSideViewCameraNode", recursively: true)!
        followPortraitCameraNode = scene.rootNode.childNode(withName: "FollowPortraitCameraNode", recursively: true)!
        followLandscapeCameraNode = scene.rootNode.childNode(withName: "FollowLandscapeCameraNode", recursively: true)!
        followBirdsEyeCameraNode = scene.rootNode.childNode(withName: "FollowBirdEyeCameraNode", recursively: true)!
     
        
    }
    
    /** Bind the camera nodes from the SCNScene file to references in code **/
    
    func setupCameras(){
        birdsEyeCamera = scene.rootNode.childNode(withName: "BirdsEyeCamera", recursively: true)!
        sideViewCamera = scene.rootNode.childNode(withName: "SideViewCamera", recursively: true)!
        portraitCamera = scene.rootNode.childNode(withName: "PortraitCamera", recursively: true)!
        landscapeCamera = scene.rootNode.childNode(withName: "LandscapeCamera", recursively: true)!
        firstPersonCamera = scene.rootNode.childNode(withName: "FirstPersonCamera", recursively: true)!
        
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
    
    func updateCameraPositions(){
        
        followBirdsEyeCameraNode.position = basicCharacter.node.presentation.position
        followPortraitCameraNode.position = basicCharacter.node.presentation.position
        followLandscapeCameraNode.position = basicCharacter.node.presentation.position
        followSideViewCameraNode.position = basicCharacter.node.presentation.position
        followFirstPersonCameraNode.position = basicCharacter.node.presentation.position
    
    }
    
   
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
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
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    //MARK: ****************TouchesBegan
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first!
        let location = touch.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if let node = hitResults.first?.node{
            
            if(gameHelper.state == .Playing){
                
                
                if(node.name == "basicCharacter"){
                    print("Touched the character, will jjump button")
                    basicCharacter.jump()
                }
            }
            
            /**
            if(game.state == .tapToPlay){
                if(node.name == "StartGame"){
                    print("Touched the start game button")
                    startGame()
                }
                
                if(node.name == "DifficultyBox"){
                    print("Touched the diffiuclt box")
                    
                    positionPreambleMainMenu(inFrontOfCamera: false)
                    positionPreambleDifficultyMenu(isInFrontOfCamera: true)
                }
                
                if(node.name == "EasyBox"){
                    positionPreambleMainMenu(inFrontOfCamera: true)
                    positionPreambleDifficultyMenu(isInFrontOfCamera: false)
                    game.difficultyLevel = .Easy
                    loadTargetWords()
                }
                
                if(node.name == "MediumBox"){
                    positionPreambleMainMenu(inFrontOfCamera: true)
                    positionPreambleDifficultyMenu(isInFrontOfCamera: false)
                    game.difficultyLevel = .Medium
                    loadTargetWords()
                    
                }
                
                if(node.name == "HardBox"){
                    positionPreambleMainMenu(inFrontOfCamera: true)
                    positionPreambleDifficultyMenu(isInFrontOfCamera: false)
                    game.difficultyLevel = .Hard
                    loadTargetWords()
                    
                }
            }
            
            
            if(game.state == .missionCompleted){
                
                if(node.name == CloudGenerator.MenuNodeType.backMainMenuCloud.rawValue){
                    print("Going back to main menu")
                    startPreamble()
                    positionGameWinMenu(hasWonGame: false)
                }
                
                if(node.name == CloudGenerator.MenuNodeType.nextLevelCloud.rawValue){
                    print("Loading next level")
                    loadGame(isRestart: false, gameLevel: (self.game.level + 1))
                    positionGameWinMenu(hasWonGame: false)
                    
                    
                }
            }
            
            if(game.state == .gameOver){
                
                if(node.name == CloudGenerator.MenuNodeType.restartGameCloud.rawValue){
                    print("Restarting current game scene")
                    loadGame(isRestart: true, gameLevel: self.game.level)
                    positionGameLossMenu(hasLostGame: false, tooManyNodes: false)
                    
                    
                }
                
                if(node.name == CloudGenerator.MenuNodeType.backMainMenuCloud.rawValue){
                    print("Back to main menu")
                    startPreamble()
                    positionGameLossMenu(hasLostGame: false, tooManyNodes: false)
                }
                
            }
            
            if(game.state == .playing){
                
                if(node.name == CloudGenerator.MenuNodeType.pauseGameCloud.rawValue){
                    print("YOU TOUCHED THE PAUSE BUTTON")
                    
                    if(self.worldNode.isPaused){
                        self.positionMainMenu(isInFrontOfCamera: false)
                        self.worldNode.isPaused = false
                    } else {
                        self.positionMainMenu(isInFrontOfCamera: true)
                        self.worldNode.isPaused = true
                    }
                    return
                }
                
                
                
                if(node.name == CloudGenerator.MenuNodeType.restartGameCloud.rawValue){
                    loadGame(isRestart: true, gameLevel: self.game.level)
                    return
                }
                
                if(node.name == CloudGenerator.MenuNodeType.backMainMenuCloud.rawValue){
                    startPreamble()
                    return
                }
                
                if(node.name == CloudGenerator.MenuNodeType.saveGameCloud.rawValue){
                    return
                }
                
                if(node.name == "IntroPanel"){
                    
                    node.removeFromParentNode()
                    self.canStartSpawning = true
                    worldNode.isPaused = false
                    return
                    
                }
                
                
                
                handleTouchFor(node: node)
                
            }
            
        
 
         **/
        }
        
    }

}



extension GameViewController: SCNSceneRendererDelegate{

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        /**
        let eulerY = carNode.presentation.eulerAngles.y
        print("The adjusted euler angle for the car is: \(eulerY)")
        
        
        if(carNode.physicsBody != nil){
            print("Applying thrust to car")
            carNode.physicsBody?.applyForce(self.carThrustVector, asImpulse: false)

        }
     **/
        
        if(gameHelper.state == .Playing){
            
            updateCameraPositions()

        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        
        if(gameHelper.state == .Playing){
            
            basicCharacter.updateCollisionNodePosition()

        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
        
    }
}



