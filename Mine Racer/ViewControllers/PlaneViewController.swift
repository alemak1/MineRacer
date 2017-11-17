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
import SpriteKit

class PlaneViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var indicatorViewCenterXConstraint: NSLayoutConstraint!
    
    var queueManager: QueueManager?
    
    //MARK: SCNView
    
    var scnView: SCNView!
    
    //MARK: ******** Scenes

    var scnScene: SCNScene!
    var preambleScene: SCNScene!
    
    //MARK: ******** Preamble Reference Nodes
    
    var startMenu: SCNNode!
    var gameOptionsMenu: SCNNode!
    var levelTrackMenu: SCNNode!
    var planeColorMenu: SCNNode!
    
    var startGameOption: SCNNode!
    var gameDifficultyOption: SCNNode!
    var levelTracksOption: SCNNode!
    var planeColorOption: SCNNode!
    
    var redOption: SCNNode!
    var yellowOption: SCNNode!
    var blueOption: SCNNode!
    
    var hardOption: SCNNode!
    var mediumOption: SCNNode!
    var easyOption: SCNNode!
    
    var spaceShipsOption: SCNNode!
    var fireballsOption: SCNNode!
    var turretsOption: SCNNode!
    var spikeBallsOption: SCNNode!
    
    
    var lastContactNode: SCNNode!
    
    var gameHelper: GameHelper{
        return GameHelper.sharedInstance
    }
    
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
    var turretManager: TurretManager!
    
    var currentWord: String?
    var wordInProgress: String?
    var restartWord: String?
    var tempWord: String?
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
    
    //MAKR:     Word Arrays
    
    var easyWords: [String]?
    var mediumWords: [String]?
    var hardWords: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        indicatorViewCenterXConstraint.constant = -2000
        activityIndicator.stopAnimating()
 
        
        setupView()
        
        
    
        setupPreambleScene()
        
        setupPreambleNodes()
        
        loadPreambleScene()
         
    }
    
    
    func loadAppIconScene(){
        scnView.scene = SCNScene(named: "art.scnassets/scenes/AppIconScene.scn")
    }
    
    func loadPreambleScene(){
        
        scnView.scene = self.preambleScene
        
    }
    
    func loadGame(){
        
        
        activityIndicator.startAnimating()
        
        preloadTargetWordArray()
        
        configureDifficultyAdjustedWord()
        
        resetWordInProgress()
        
        //TODO: combine in a single function and load/update managers dynamically based upon current level track
        
        
        loadTurretManager()
        
        loadFireballManager()
        
        loadSpikeBallManager()
        
        loadLetterRingManager()
        
        loadSpaceCraftManager()
        
    
        loadScene()
        
        setupNodes()
        
        setupCameras()
        
        setupHUD()
        
        loadMenuNode()
        
        setupGestureRecognizers()
        
        changePointOfView(to: .Portrait)
        
        gameHelper.state = .Playing
        
        
        loadEncounterSeries()
        
        startEncounterSeries()
        
        activityIndicator.stopAnimating()
        indicatorViewCenterXConstraint.constant = -2000
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func cleanUpEnemyManagers(){
        self.fireballManager = nil
        self.spikeBallManager = nil
        self.spaceCraftManager = nil
        self.turretManager = nil
        self.letterRingManager = nil
    }
    
    
    func resetWordInProgress(){
        self.wordInProgress = nil
        self.wordInProgress = String()
        self.tempWord = nil
        self.tempWord = self.currentWord!
    }
    
    func preloadTargetWordArray(){
        
        self.easyWords = nil
        self.mediumWords = nil
        self.hardWords = nil
        
        let path = Bundle.main.path(forResource: "TargetWords", ofType: "plist")!
       
        let wordsDict = NSDictionary(contentsOfFile: path)!
   
        let wordsArray = wordsDict[gameHelper.difficulty.rawValue] as! [String]
        
        switch self.gameHelper.difficulty {
        case .Easy:
            self.easyWords = wordsArray
            break
        case .Medium:
            self.mediumWords = wordsArray
            break
        case .Hard:
            self.hardWords = wordsArray
            break
        }
        
    }
    
    func configureDifficultyAdjustedWord(){
        
        if let restartWord = self.restartWord{
            
            setCurrentWord(with: restartWord)
            
        } else {
        
        var targetWord: String!
        
            if let easyWords = self.easyWords{
            
                targetWord = easyWords.getRandomElement() as! String

            
            } else if let hardWords = self.hardWords{
            
                targetWord = hardWords.getRandomElement() as! String
      
            
            } else if let mediumWords = self.mediumWords{
            
                targetWord = mediumWords.getRandomElement() as! String

            }
        
        
            setCurrentWord(with: targetWord)
        }
    }
    
    
    //MARK: ******************** Gameplay Menu Options
    
    /** Helper functions for setting up menu buttons that can be used during gameplay **/
    
    func showGameLossMenu(withReason reasonText: String){
        
        self.gameOverMenu = SCNNode()
        
        let reasonButton = getMenuButton(withName: reasonText, andPosition: .upper3)
        self.gameOverMenu.addChildNode(reasonButton)

        let restartButton = getMenuButton(withName: "Restart Level", andPosition: .upper2)
        self.gameOverMenu.addChildNode(restartButton)

        let backToMainMenu = getMenuButton(withName: "Back To Main Menu", andPosition: .upper1)
        self.gameOverMenu.addChildNode(backToMainMenu)

        self.menuNode.addChildNode(self.gameOverMenu)
        self.gameOverMenu.position = MenuPosition.GameOver.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true

    }
    
    func showGameWinMenu(){
        
        self.gameWinMenu = SCNNode()
        
        let backToMenuButton = getMenuButton(withName: "Back to Main Menu", andPosition: .upper3)
        self.gameWinMenu.addChildNode(backToMenuButton)
        
        let nextLevelButton = getMenuButton(withName: "Next Level", andPosition: .upper2)
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
        
        let text = SCNText(string: name, extrusionDepth: 0.50)
        text.font = UIFont.init(name: "Didot", size: 1.0)
        
        let diffuseMaterial = SCNMaterial()
        diffuseMaterial.diffuse.contents = SKColor.red
        text.materials = [diffuseMaterial]
        
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
        
        let redCoating = SCNMaterial()
        redCoating.diffuse.contents = SKColor.red
        pauseText.materials = [redCoating]
        
        let pauseButton = SCNNode(geometry: pauseText)
        
        pauseButton.name = "pauseButton"
        
        self.menuNode.addChildNode(pauseButton)
        
        self.portraitCamera.addChildNode(self.menuNode)
        self.menuNode.position = SCNVector3.init(-0.5, -7.0, -12)
    }
    
    func loadEncounterSeries(){
        
        print("Loading encounter series of Level Track: \(gameHelper.levelTrack.rawValue), for Difficulty Level of: \(gameHelper.difficulty.rawValue), Level: \(gameHelper.level)")
        
        
        if let currentEncounterSeries = self.currentEncounterSeries{
            
            currentEncounterSeries.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.currentEncounterSeries = EncounterSeries.GenerateEncounterSeries(forPlaneViewController: self, forLevelTrack: gameHelper.levelTrack, andforLevel: gameHelper.level)


        self.currentEncounterSeries!.showFirstEncounterInformation()
        
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
    
    
    /** Helper functions for setting up the Preamble **/
    
    func loadScene(){
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.50)
    
        
        scnScene = SCNScene(named: "art.scnassets/scenes/blue_scene.scn")
        
        scnScene.physicsWorld.contactDelegate = self
        
        scnScene.background.contents = BackgroundManager.GetRandomSkyBoxPath()
        
        scnView.present(self.scnScene, with: transition, incomingPointOfView: nil, completionHandler: nil)
        
    }
    
    func setupPreambleNodes(){
        
        
        /** Option Menus **/
        
        self.startMenu = preambleScene.rootNode.childNode(withName: "StartMenu", recursively: true)!
        self.gameOptionsMenu = preambleScene.rootNode.childNode(withName: "GameOptions", recursively: true)!
        self.levelTrackMenu = preambleScene.rootNode.childNode(withName: "LevelTracks", recursively: true)!
        self.planeColorMenu = preambleScene.rootNode.childNode(withName: "PlaneColors", recursively: true)!
        
        /** Start Menu Options **/
        
        self.startGameOption = self.startMenu.childNode(withName: "StartGame", recursively: true)!
        self.gameDifficultyOption = self.startMenu.childNode(withName: "GameOptions", recursively: true)!
        self.levelTracksOption = self.startMenu.childNode(withName: "LevelTracks", recursively: true)!
        self.planeColorOption = self.startMenu.childNode(withName: "PlaneColors", recursively: true)!
        
        
        /** Plane Color Options **/
        
        self.redOption = self.planeColorMenu.childNode(withName: "Red", recursively: true)!
        self.blueOption = self.planeColorMenu.childNode(withName: "Blue", recursively: true)!
        self.yellowOption = self.planeColorMenu.childNode(withName: "Yellow", recursively: true)!
        
        /** Game Difficulty Options **/
        
        self.hardOption = self.gameOptionsMenu.childNode(withName: "Hard", recursively: true)!
        self.mediumOption = self.gameOptionsMenu.childNode(withName: "Medium", recursively: true)!
        self.easyOption = self.gameOptionsMenu.childNode(withName: "Easy", recursively: true)!

        /** Game Level Track Options  **/

        self.spaceShipsOption = self.levelTrackMenu.childNode(withName: "SpaceShips", recursively: true)!
        self.turretsOption = self.levelTrackMenu.childNode(withName: "Turrets", recursively: true)!
        self.fireballsOption = self.levelTrackMenu.childNode(withName: "FireBalls", recursively: true)!
        self.spikeBallsOption = self.levelTrackMenu.childNode(withName: "SpikeBalls", recursively: true)!
        
        positionStartMenu(isShowing: true)


    }
    
    func setupPreambleScene(){
        
        preambleScene = SCNScene(named: "art.scnassets/scenes/SplashScene.scn")
        
        gameHelper.state = .TapToPlay


    }
    
    //MARK: ************** Position Functions for Positioning the Preamble Menus
    
    func positionPlaneColorOptionsMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.planeColorMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        } else{
            
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.planeColorMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        }
    }
    
    func positionGameOptionsMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.gameOptionsMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))

        } else{
            
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.gameOptionsMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))

        }
    }
    
    func positionStartMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, 0.0, -42.0)
            self.startMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))

        } else{
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.startMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
        }
    }
    
    func positionLevelTracksMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.levelTrackMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))

        } else{
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.levelTrackMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))

        }
    }
    
    
    func loadTurretManager(){
        turretManager = TurretManager(with: self)
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
        
        let planeName = gameHelper.planeType.getPlaneReferenceNodeName()
        
        let planeReferenceNode = scnScene.rootNode.childNode(withName: planeName, recursively: true)!
        
        player = Plane(withReferenceNode: planeReferenceNode)
        
        player.node.position = SCNVector3.init(0.0, 0.0, 0.0)
        
        followPortraitCameraNode = scnScene.rootNode.childNode(withName: "followPortraitCamera", recursively: true)!
        followLandscapeCameraNode = scnScene.rootNode.childNode(withName: "followLandscapeCamera", recursively: true)!
        
        worldNode = SCNNode()
        scnScene.rootNode.addChildNode(worldNode)
        
    
       
    }
    
    /** Bind the camera nodes from the SCNScene file to references in code **/
    
    func setupCameras(){
        
        
        portraitCamera = scnScene.rootNode.childNode(withName: "portraitCamera", recursively: true)!
        landscapeCamera = scnScene.rootNode.childNode(withName: "landscapeCamera", recursively: true)!
    
     

    }

    func returnToMainMenu(){
        let transition = SKTransition.flipVertical(withDuration: 0.50)
        self.scnView.present(self.preambleScene, with: transition, incomingPointOfView: nil, completionHandler: {
            
            self.positionStartMenu(isShowing: true)
            self.gameHelper.state = .TapToPlay
            self.currentWord = nil
            self.restartWord = nil
            if let currentEncounterSeries = self.currentEncounterSeries{
                currentEncounterSeries.terminateEncounterSeries()
                self.currentEncounterSeries = nil
            }
            self.gameHelper.level = 1
            self.cleanUpEnemyManagers()
            
        })
    }
    
    func restartCurrentLevel(){
        self.cleanUpEnemyManagers()
        if let currentEncounterSeries = self.currentEncounterSeries{
            currentEncounterSeries.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.restartWord = self.currentWord!
        
        loadGame()
    }
    
    func loadNextLevel(){
        
        gameHelper.level += 1
        self.cleanUpEnemyManagers()
        
      
        
        if let currentEncounter = self.currentEncounterSeries{
            currentEncounter.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.currentWord = nil
        self.restartWord = nil
        
        loadGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if let node = hitResults.first?.node{
            
            if(gameHelper.state == .GameOver){
                
                
                if(node.name == nil){
                    return
                }
                
                
                switch node.name!{
                    case "Next Level":
                        loadNextLevel()
                        break
                    case "Back to Main Menu":
                        returnToMainMenu()
                        break
                    case "Restart Level":
                       restartCurrentLevel()
                        break
                    default:
                        break
                }
                
            }
            
            
            if(gameHelper.state == .TapToPlay){
                
                if(node.name == nil){
                    return
                }
                
                switch node.name!{
                    case "StartGame":
                        positionStartMenu(isShowing: false)
                        loadGame()
                        break
                    case "GameOptions":
                        positionGameOptionsMenu(isShowing: true)
                        positionStartMenu(isShowing: false)
                        break
                    case "LevelTracks":
                        positionLevelTracksMenu(isShowing: true)
                        positionStartMenu(isShowing: false)
                        break
                    case "PlaneColors":
                        positionPlaneColorOptionsMenu(isShowing: true)
                        positionStartMenu(isShowing: false)
                        break
                    case "Red":
                        gameHelper.planeType = .red
                        positionPlaneColorOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Blue":
                        gameHelper.planeType = .blue
                        positionPlaneColorOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Yellow":
                        gameHelper.planeType = .yellow
                        positionPlaneColorOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Hard":
                        gameHelper.difficulty = .Hard
                        positionGameOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Medium":
                        gameHelper.difficulty = .Medium
                        positionGameOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Easy":
                        gameHelper.difficulty = .Easy
                        positionGameOptionsMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "SpaceShips":
                        gameHelper.levelTrack = .SpaceShips
                        positionLevelTracksMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "SpikeBalls":
                        gameHelper.levelTrack = .SpikeBalls
                        positionLevelTracksMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                     case "FireBalls":
                        gameHelper.levelTrack = .FireBalls
                        positionLevelTracksMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    case "Turrets":
                        gameHelper.levelTrack = .Turrets
                        positionLevelTracksMenu(isShowing: false)
                        positionStartMenu(isShowing: true)
                        break
                    default:
                        print("No logic implemented for this node")
                        break

                }

            }
            
            if(gameHelper.state == .Playing){
                
                if(node.name == nil){
                    return
                }
                
                if node.name == "pauseButton"{
                    
                    if(self.scnScene.isPaused){
                        self.removeGamePauseMenu()
                    } else{
                        self.setupGamePauseMenu()
                    }
                    
                    
                    print("Game has been paused")
                    return
                }
                
                
                switch node.name!{
                    case "Restart Level":
                        restartCurrentLevel()
                        break
                    case "Back To Main Menu":
                        returnToMainMenu()
                        break
                    default:
                        break
                    
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
        
        
        if(gameHelper.state == .Playing){
            
            if(self.scnScene.isPaused || self.worldNode.isPaused){
                return
            }
            
            if(player.health <= 0){
                gameHelper.state == .GameOver
                showGameLossMenu(withReason: "Out of Lives!")
            }
            
            if let wordInProgress = self.wordInProgress, let currentWord = self.currentWord{
        
                if(wordInProgress == currentWord){
                    self.worldNode.runAction(
                        SCNAction.sequence([
                            SCNAction.wait(duration: 1.00),
                        
                            SCNAction.run({_ in
                                self.gameHelper.state = .GameOver
                                self.showGameWinMenu()

                            })]))
                }
            }
            

            letterRingManager.update(with: time)
            spaceCraftManager.update(with: time)
            fireballManager.update(with: time)
            turretManager.update(with: time)
            
            cleanExcessNodes()
            
            updateCameraPositions()
            
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
                if let letterName = contactNode.name,let contactLetter = letterName.last, let nextLetter = self.tempWord?.first{
                    if contactLetter == nextLetter{
                        
                        self.tempWord?.removeFirst()
                        self.wordInProgress!.append(contactLetter)
                        print("The current word is \(self.wordInProgress!)")
                        self.hud.updateHUD()



                    }
                    
                }
               
            
                break
        case CollisionMask.DetectionNode.rawValue:
            print("Player has been detected by the space craft")
            print("The contactNode name is \(contactNode.name!)")
            if(contactNode.name != nil && (contactNode.name!.contains("SpaceCraft") || contactNode.name!.contains("Turret"))){
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
