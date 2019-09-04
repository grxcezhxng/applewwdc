// Created by Grace Zhang. Mouse click to pause and resume the play
import PlaygroundSupport
import SpriteKit
import UIKit

class GameScene: SKScene {

    private var girl = SKSpriteNode()
    private var WalkingFrames: [SKTexture] = []
    var arrayBGs :[SKSpriteNode] = [SKSpriteNode]()
    var arrayHearts :[SKSpriteNode] = [SKSpriteNode]()
    var midX = CGFloat(0);

    let meterbar = SKSpriteNode(color: UIColor(red: 0.96, green: 0.75, blue: 0.85, alpha: 1.0), size: CGSize(width: 160, height: 20))
    let meterbar2 = SKSpriteNode(color: UIColor(red: 0.82, green: 0.72, blue: 0.76, alpha: 1.0), size: CGSize(width: 0, height: 20))
    
    let bgimg = SKSpriteNode(imageNamed: "bg0.png")
    let continueButton = SKSpriteNode(imageNamed: "continueButton.png")
    let firstScreen = SKSpriteNode(imageNamed: "first.png")
    let secondScreen = SKSpriteNode(imageNamed: "second.png")
    let endScreen = SKSpriteNode(imageNamed: "end.png")

    
    let mspeed = CGFloat(1.1)
    let walkingspeed = CGFloat(0.4)
    var stopMoving = true
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score: Int = 0
    var screenNum: Int = 1
    
    var backgroundMusic: SKAudioNode!
    var walkingMusic: SKAudioNode!
    var collidedMusic: SKAudioNode!

    func buildWalkingGirl() {
        let m1 = SKTexture(imageNamed: "girl1.png")
        let m2 = SKTexture(imageNamed: "girl2.png")
        let m3 = SKTexture(imageNamed: "girl3.png")
        
        WalkingFrames = [m1, m2, m3, m2]
        girl = SKSpriteNode(texture: m1)
        girl.position = CGPoint(x: frame.midX, y: 70)
        addChild(girl)
    }
    
    func animateGirl() {
        girl.run(SKAction.repeatForever(
            SKAction.animate(with: WalkingFrames,timePerFrame: 0.1)), withKey:"moving")
        resumeGirlWalking()
     }
    
    func pauseGirlWalking() {
        if let action = girl.action(forKey: "moving") {
            action.speed = 0
        }
    }
    
    func resumeGirlWalking() {
        if let action = girl.action(forKey: "moving") {
            action.speed = walkingspeed
        }
    }
    
    func buildSlides() {
        var imageName = "bg"
        var xpos = CGFloat(300)
       
        for s in 1...8 {
            imageName = "bg" + "\(s)" + ".png"
            let bg = SKSpriteNode(imageNamed:imageName)
            bg.anchorPoint = CGPoint(x:0, y:0)
            bg.zPosition = 2;
            bg.position = CGPoint(x:xpos-1, y:110)
            self.addChild(bg)
            arrayBGs.append(bg)
            
            let ht = SKSpriteNode(imageNamed: "heart.png")
            ht.anchorPoint = CGPoint(x:0, y:0)
            ht.zPosition = 2
            ht.position = CGPoint(x:xpos+bg.size.width/2, y:60)
            arrayHearts.append(ht)
            self.addChild(ht)
            xpos += CGFloat(bg.size.width)
        }
        
        bgimg.position = CGPoint(x:frame.midX, y:frame.midY)
        addChild(bgimg)
        
        firstScreen.position = CGPoint(x:frame.midX, y:frame.midY)
        addChild(firstScreen)
        secondScreen.position = CGPoint(x:-360, y:0)
        addChild(secondScreen)
        
        continueButton.position = CGPoint(x:-self.frame.midX, y:390)
        addChild(continueButton)
        
        endScreen.position = CGPoint(x:-500, y:0)
        addChild(endScreen)
    }
    
    func buildConfidenceBar() {
        meterbar.position = CGPoint(x:midX+70, y:450)
        meterbar.zPosition = 2
        addChild(meterbar)
        meterbar2.position = CGPoint(x:midX+70, y:450)
        meterbar2.zPosition = 2
        addChild(meterbar2)
        
        scoreLabel.text = "Confidence:"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor(red: 0.375, green: 0.375, blue: 0.375, alpha: 1.0)
        scoreLabel.position = CGPoint(x: 80, y: 440)
        addChild(scoreLabel)
    }
    
    func hideConfBarGirl(){
        scoreLabel.zPosition = -2
        meterbar.zPosition = -2
        meterbar2.zPosition = -2
    //    girl.zPosition = -2
    }
    
    func showConfBarGirl(){
        scoreLabel.zPosition = 2
        meterbar.zPosition = 2
        meterbar2.zPosition = 2
        girl.zPosition = 2
    }
    
    func readMusicFiles() {
        let bgmusic = SKAudioNode(fileNamed: "backgroundmusic.mp3")
        addChild(bgmusic)
        backgroundMusic = bgmusic
    }
    
    override func didMove(to view: SKView) {

        self.backgroundColor = .white
        midX = size.width/2
        print("loading images ......")
        buildSlides()
        print("creating scenes ......")
        buildWalkingGirl()
        animateGirl()
        buildConfidenceBar()
        hideConfBarGirl()
        print("loading music ......")
        readMusicFiles()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if (score < 8) {
            if (screenNum == 2)
            {
                secondScreen.position = CGPoint(x:firstScreen.position.x - 360, y:firstScreen.position.y)
                screenNum += 1
                stopMoving = false
                resumeGirlWalking()
                showConfBarGirl()
            }
            else if (screenNum == 1 )
            {  
               firstScreen.position = CGPoint(x:firstScreen.position.x - 360, y:firstScreen.position.y)
                secondScreen.position = CGPoint(x:frame.midX, y:frame.midY)
                screenNum += 1
            }
            else
            {
               screenNum += 1
                stopMoving = !stopMoving
                if (stopMoving) {
                    pauseGirlWalking()
                }
                else {
                    resumeGirlWalking()
                }
            }
           
        } else {
            arrayBGs[7].position = CGPoint(x: arrayBGs[7].position.x - 360, y:arrayBGs[7].position.y)
            continueButton.zPosition = -2
            hideConfBarGirl()
            girl.zPosition = -2
            endScreen.position = CGPoint(x:frame.midX, y:frame.midY)
            backgroundMusic.run(SKAction.stop())
        }
       
    }
    
   override func update(_ currentTime: TimeInterval) {
    
        if (screenNum == 1) {
            pauseGirlWalking()
           return
        }
    
        if (arrayBGs[7].position.x > -80 && !stopMoving) {
          for s in 0...7 {
            arrayBGs[s].position = CGPoint(x: arrayBGs[s].position.x - mspeed, y:arrayBGs[s].position.y)
            
            if (arrayHearts[s].position.x < midX + 2*mspeed && arrayHearts[s].position.x > midX  ){
     
                arrayHearts[s].position = CGPoint(x: -100, y:arrayHearts[s].position.y)
                score = score + 1
                meterbar2.size.width = CGFloat(score * 20)
                let  wd = CGFloat(8-score)*CGFloat(10)
                meterbar2.position = CGPoint(x:midX + 70 - wd,  y:450)
                continue
              }
             else {
                
                    if ( Int(currentTime) % 2 == 0  ) {
                        arrayHearts[s].position = CGPoint(x: arrayHearts[s].position.x - mspeed, y:arrayHearts[s].position.y+0.3)
                    }
                    else
                    {
                        arrayHearts[s].position = CGPoint(x: arrayHearts[s].position.x - mspeed, y:arrayHearts[s].position.y-0.3)
                    }
              }
            }
        }
         else
        {
            if (score == 8) {
              
                continueButton.position = CGPoint(x:self.frame.midX, y:continueButton.position.y)
                backgroundMusic.run(SKAction.stop())
                score = 100;
                pauseGirlWalking()
            }
        }
    }
}

// Load the SKScene
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 360, height: 480))
sceneView.backgroundColor = .white
let scene = GameScene (size: sceneView.frame.size)
scene.backgroundColor = .white
scene.scaleMode = .aspectFill
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

