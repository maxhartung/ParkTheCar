import SpriteKit

class GameScene: SKScene {
    
    //MARK:- SKSprites
    
    let background : SKSpriteNode = {
        let background = SKSpriteNode(color: UIColor.systemGreen,size: CGSize(width: 100, height: 100))
        background.zPosition = 0
        return background
    }()
    
    let scoreLabel : SKLabelNode = {
        let scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .black
        scoreLabel.text = "You parked 0 cars"
        scoreLabel.horizontalAlignmentMode = .right
        return scoreLabel
    }()
    
    //MARK:- Properties

    var cars : [Car] = []
    var parkingSpots : [SKShapeNode] = []
    var parkedCars : Int = 0
    
    //MARK:- Events

    override func didMove(to view: SKView) {
        setupInitialGameScene()
        createParkingSpots()
        createCars()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousTouch = touch.previousLocation(in: self)
            
            let amountX = pointOfTouch.x - previousTouch.x
            let amountY = pointOfTouch.y - previousTouch.y
            
            
            for car in cars {
                if car.skSpriteNode.contains(CGPoint(x: pointOfTouch.x, y: pointOfTouch.y)){
                    car.skSpriteNode.position.x += amountX
                    car.skSpriteNode.position.y += amountY
                }
            }
            
            for (index1,parkingSpot) in parkingSpots.enumerated() {
                for (index,car) in cars.enumerated() {
                    if parkingSpot.frame.contains(car.skSpriteNode.frame) {
                        cars[index].parkedOn = index1
                        scoreLabel.text = "You parked \(cars.filter({ $0.parkedOn != 100}).count ) cars"
                    } else if car.parkedOn == index1{
                        cars[index].parkedOn = 100
                        scoreLabel.text = "You parked \(cars.filter({ $0.parkedOn != 100}).count ) cars"
                    }
                }
            }
        }
    }
    
    // MARK:- Create and Setup Game Scene
    
    func setupInitialGameScene(){
        background.size = self.size
        
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        scoreLabel.position = CGPoint(x: self.frame.maxX - 15, y: self.frame.maxY - 25)
        
        addChild(scoreLabel)
        addChild(background)
    }
    
    func createParkingSpots(){
        
        var previousParkingSpotLocation : CGPoint = CGPoint(x: frame.minX + 30, y: frame.maxY - 20)
        
        for _ in 0...4 {
            let parkingSpot = SKShapeNode()
            parkingSpot.path = UIBezierPath(roundedRect: CGRect(x:  -128, y:  -128, width: 80, height: 110), cornerRadius: 12).cgPath
            parkingSpot.position = CGPoint(x: previousParkingSpotLocation.x + parkingSpot.frame.size.width + 30, y: previousParkingSpotLocation.y)
            parkingSpot.fillColor = UIColor.clear
            parkingSpot.strokeColor = UIColor.white
            parkingSpot.lineWidth = 5
            parkingSpot.zPosition = 1
            parkingSpots.append(parkingSpot)
            addChild(parkingSpot)
            previousParkingSpotLocation = CGPoint(x: parkingSpot.position.x, y: parkingSpot.position.y)
        }
    }
    
    func createCars(){
        var previousCarLocation : CGPoint = CGPoint(x: frame.minX + 50, y: frame.minY + 55)
        
        for index in 0...4 {
            let car = SKSpriteNode(imageNamed: "car")
            car.zPosition = 2
            car.scale(to: CGSize(width: 80, height: 80))
            
            if index != 0 {
                car.position = CGPoint(x: previousCarLocation.x + 50, y: previousCarLocation.y)
            } else {
                car.position = CGPoint(x: previousCarLocation.x, y: previousCarLocation.y)
            }
            self.addChild(car)
            previousCarLocation = CGPoint(x: car.position.x, y: car.position.y)
            
            let carObj = Car(skSpriteNode: car, parkedOn: 100)
            cars.append(carObj)
        }
    }
}
