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
    
    var lastContactNode: SCNNode!
    
    var gameHelper = GameHelper.sharedInstance
    var hud: HUD!
    
    var mainHUDnode: SCNNode{
        return hud.hudNode
    }
    
    
    var player: Plane!
    
    var worldNode: SCNNode!
    var menuNode: SCNNode!
    var pauseMenu: SCNNode!
    var gameOverMenu: SCNNode!
    var gameWinMenu: SCNNode!
    
    var followPortraitCameraNode: SCNNode!
    var followLandscapeCameraNode: SCNNode!
    
    var portraitCamera: SCNNode!
    var landscapeCamera: SCNNode!
    
    var letterRingManager: LetterRingManager!
    var spaceCraftManager: SpaceCraftManager!
    var spikeBallManager: SpikeBallManager!
    var fireballManager: FireballManager!
    
    var currentWord: String?
    var wordInProgress: String?
    
    var spawnPoints: [[SCNVector3]]?
    
    var lastUpdatedTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var ringExpansionInterval = 4.00
    
    var currentEncounterSeries: EncounterSeries?
    var encounterIsFinished: Bool = false{
        didSet{
            if(encounterIsFinished == true){
                gameHelper.state == .GameOver
             
                showGameLossMenu(withReason: "Time Up!")
                print("Encounter is finished...Game over")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setCurrentWord(with: "love")

        loadFireballManager()
        
        loadSpikeBallManager()
        
        loadLetterRingManager()
        
        loadSpaceCraftManager()
        
        loadScene()
        
        setupView()
        
        setupNodes()
        
        setupCameras()
        
        setupHUD()

        loadMenuNode()
        
        setupGestureRecognizers()
        
        changePointOfView(to: .Portrait)
        
        gameHelper.state = .Playing
        
        
       // let tunnel2 = EnemyGenerator.sharedInstance.getSpikeTunnel(of: .ST2)
       // worldNode.addChildNode(tunnel2)
       // tunnel2.position = SCNVector3(x: -10.0, y: 5.0, z: -100)
        
        
        
       
        loadEncounterSeries()
        
        startEncounterSeries()

    }
    
    func showGameLossMenu(withReason reasonText: String){
        
        self.gameOverMenu = SCNNode()
        
        let reasonButton = getMenuButton(withName: reasonText, andPosition: .upper2)
        self.gameOverMenu.addChildNode(reasonButton)

        let restartButton = getMenuButton(withName: "Restart Level", andPosition: .upper1)
        self.gameOverMenu.addChildNode(restartButton)

        let backToMainMenu = getMenuButton(withName: "Back To Main Menu", andPosition: .lower1)
        self.gameOverMenu.addChildNode(backToMainMenu)

        self.menuNode.addChildNode(self.gameOverMenu)
        self.gameOverMenu.position = MenuPosition.GameOver.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true

    }
    
    func showGameWinMenu(){
        
        self.gameWinMenu = SCNNode()
        
        let backToMenuButton = getMenuButton(withName: "Back to Main Menu", andPosition: .upper1)
        self.gameWinMenu.addChildNode(backToMenuButton)
        
        let nextLevelButton = getMenuButton(withName: "Next Level", andPosition: .lower1)
        self.gameWinMenu.addChildNode(nextLevelButton)
        
        
        self.menuNode.addChildNode(self.gameWinMenu)
        self.gameWinMenu.position = MenuPosition.GameWin.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true
    }
    
    func setupGamePauseMenu(){
        
        self.pauseMenu = SCNNode()
        
        let restartButton = getMenuButton(withName: "Restart Level", andPosition: .upper1)
        self.pauseMenu.addChildNode(restartButton)
        
        let backToMainMenuButton = getMenuButton(withName: "Back To Main Menu", andPosition: .lower1)
        self.pauseMenu.addChildNode(backToMainMenuButton)
        
        self.menuNode.addChildNode(self.pauseMenu)
        self.pauseMenu.position = MenuPosition.PauseMenu.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true
        
    }
    
    func getMenuButton(withName name: String, andPosition menuPosition: MenuPosition) -> SCNNode{
        
        let text = SCNText(string: name, extrusionDepth: 0.10)
        text.font = UIFont.init(name: "Avenir", size: 1.0)
        let button = SCNNode(geometry: text)
        button.name = name
        button.position = menuPosition.getPosition()
        return button
    }
    
    
    func removeGamePauseMenu(){
        if(self.pauseMenu == nil){
            return
        }
        
        self.pauseMenu.removeFromParentNode()
        
        worldNode.isPaused = false
        self.scnScene.isPaused = false
    }
    
    func removeGameOverMenu(){
        if(self.gameOverMenu == nil){
            return
        }
        
        self.gameOverMenu.removeFromParentNode()
    }
    
    func removeGameWinMenu(){
        if(self.gameWinMenu == nil){
            return
        }
        
        self.gameWinMenu.removeFromParentNode()
    
    }
    
    func loadMenuNode(){
        
        self.menuNode = SCNNode()
        
        let pauseText = SCNText(string: "Pause Game", extrusionDepth: 0.1)
        pauseText.chamferRadius = 0.00
        pauseText.font = UIFont.init(name: "Avenir", size: 0.7)
        pauseText.isWrapped = true
        pauseText.alignmentMode = kCAAlignmentLeft
        pauseText.truncationMode = kCATruncationNone
        let pauseButton = SCNNode(geometry: pauseText)
        pauseButton.name = "pauseButton"
        
        self.menuNode.addChildNode(pauseButton)
        
        self.portraitCamera.addChildNode(self.menuNode)
        self.menuNode.position = SCNVector3.init(0.8, -7.5, -12)
    }
    
    func loadEncounterSeries(){
        
        self.currentEncounterSeries = EncounterSeries.GenerateEncounterSeries(forPlaneViewController: self, withMaxLetter: 5, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 10, withMaxWaitTime: 3)
    }
    
    func startEncounterSeries(){
        if(self.currentEncounterSeries != nil){
            self.currentEncounterSeries!.start()

        }

    }
    
    func setupHUD(){
        self.hud = HUD(withPlaneViewController: self)
        self.portraitCamera.addChildNode(self.hud.hudNode)
        self.hud.hudNode.position = SCNVector3.init(0.0, 45.00, -100.00)
        self.hud.updateHUD()
    
    }
    
    func setCurrentWord(with word: String){
        
        self.currentWord = word.uppercased()
    }
    
    func spawnNextGameObject(){
        
        
        
    }
    

    
    
    func getRandomSpawnPoint() -> SCNVector3{
        
        let numberOfGroups = spawnPoints!.count
        let groupIdx = Int(arc4random_uniform(UInt32(numberOfGroups)))
        
        let groupSpawnPoints = self.spawnPoints![groupIdx]
        
        let numberOfPoints = groupSpawnPoints.count
        let pointIdx = Int(arc4random_uniform(UInt32(numberOfPoints)))
        
        return groupSpawnPoints[pointIdx]
    }
    
    func loadSpawnPoints(){
        
        print("Loading spawn points....")
        
        spawnPoints = [[SCNVector3]]()
        
        for node in scnScene.rootNode.childNodes{
            if node.name != nil && node.name!.contains("SpawnPointGroup"){
                
                let spawnPointGroup = node.childNodes.filter({$0.name == "SpawnPoint"}).map({$0.position})
                
                spawnPoints!.append(spawnPointGroup)
           
                
            }
        }
        
    
        spawnPoints!.forEach({
            
           spawnGroup in
            
            var i = 0

            print("Showing inform for spawn point group \(i+1)")
            
            spawnGroup.forEach({
                spawnPoint in
                
                
                print("Spawn point group \(i+1) located at x: \(spawnPoint.x), y: \(spawnPoint.y), z: \(spawnPoint.z)")
                
            })
           
            i += 1
            
        })
    }
    
    func loadScene(){
        scnScene = SCNScene(named: "art.scnassets/scenes/Level3.scn")
        
        scnScene.physicsWorld.contactDelegate = self
        
    }
    
    
    func loadFireballManager(){
        fireballManager = FireballManager(with: self)
    }
    
    func loadSpikeBallManager(){
    
        spikeBallManager = SpikeBallManager(with: self)
    
    }
    
    func loadSpaceCraftManager(){
        spaceCraftManager = SpaceCraftManager(with: self)
    }
    
    func loadLetterRingManager(){
        letterRingManager = LetterRingManager(with: self)
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
        
       // let cube = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 0.0)
       // let cubeNode = SCNNode(geometry: cube)
       // cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
       // cubeNode.physicsBody?.isAffectedByGravity = false
        /**
        cubeNode.physicsBody?.friction = 0.00
        cubeNode.physicsBody?.rollingFriction = 0.00
        cubeNode.physicsBody?.damping = 0.00
        cubeNode.physicsBody?.allowsResting = false
        **/
        
       // worldNode.addChildNode(cubeNode)
       // cubeNode.position  = SCNVector3(0.0, 3.0, -20.0)
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
                
                if node.name == "pauseButton"{
                    
                    if(self.scnScene.isPaused){
                        self.removeGamePauseMenu()
                    } else{
                        self.setupGamePauseMenu()
                    }
                    
                    
                    print("Game has been paused")
                    return
                }
                
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
        
        /** Remove HUD node from previous camera node **/
        if let currentCamera = scnView.pointOfView{
            if let hudNode = currentCamera.childNode(withName: "hud", recursively: true){
                hudNode.removeFromParentNode()
            }
        }
        
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
        
        /** Add HUD node to new camera node **/
        
        if let currentCamera = scnView.pointOfView{
                currentCamera.addChildNode(mainHUDnode)
            
        }
    }
    
    
    func updateCameraPositions(){
        
        followPortraitCameraNode.position = player.node.presentation.position
        followLandscapeCameraNode.position = player.node.presentation.position
        
    }
    
}

extension PlaneViewController: SCNSceneRendererDelegate{
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if(time == 0){
            lastUpdatedTime = 0
        }
        
        if(player.health <= 0){
            gameHelper.state == .GameOver
            showGameLossMenu(withReason: "Out of Lives!")
        }
        
        
        if(gameHelper.state == .Playing){
            
            if(self.scnScene.isPaused || self.worldNode.isPaused){
                return
            }
            
            print("Total nodes (pre-cleanup)are: \(worldNode.childNodes.count)")

            letterRingManager.update(with: time)
            spaceCraftManager.update(with: time)
            fireballManager.update(with: time)
            cleanExcessNodes()
            
            updateCameraPositions()
            
            print("Total nodes (post-cleanup) are: \(worldNode.childNodes.count)")
        }
        
        lastUpdatedTime = time
        
    }
    
    func cleanExcessNodes(){
        
        for node in worldNode.childNodes{
            if node.position.z > 30{
                node.removeFromParentNode()
            }
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

extension PlaneViewController: SCNPhysicsContactDelegate{
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        
        var contactNode: SCNNode!
        
        if contact.nodeA.name == "player"{
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        
        if lastContactNode != nil && lastContactNode == contactNode{
            return
        }
        
        switch UInt32(contactNode.physicsBody!.categoryBitMask){
            case CollisionMask.PortalCenter.rawValue:
                let letterName = contactNode.name
                print("Player contacted a letter: \(letterName)...")
                break
        case CollisionMask.DetectionNode.rawValue:
            print("Player has been detected by the space craft")
            print("The contactNode name is \(contactNode.name!)")
            if(contactNode.name != nil && contactNode.name!.contains("SpaceCraft")){
                print("Sending notificaiton...")
                NotificationCenter.default.post(name: Notification.WasDetectedBySpaceCraftNotification, object: self, userInfo: [
                    "nodeName":contactNode.name!
                    ])
            }
            break
        case CollisionMask.Bullet.rawValue:
            print("Player has been hit by a bullet")
            player.takeDamage(by: 1)
            hud.updateHUD()

            print("Current player's health is: \(self.player.health)")
            break
        case CollisionMask.Enemy.rawValue:
            print("Player has been hit by an enemy")
            player.takeDamage(by: 1)
            hud.updateHUD()

            print("Current player's health is: \(self.player.health)")
            break
        case CollisionMask.Obstacle.rawValue:
            print("Player has been hit by obstacle")
            player.takeDamage(by: 1)
            hud.updateHUD()

            print("Current player's health is: \(self.player.health)")
            break 
        default:
                print("No contact logic implemented, contactNode info - category mask: \(contactNode.physicsBody!.categoryBitMask), contact mask: \(contactNode.physicsBody!.contactTestBitMask)")
        }
        
        //TODO: implement contact logic here
        
        lastContactNode = contactNode
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }
    
    
}
