//import SpriteKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    var player: SKSpriteNode!
//
//    override func didMove(to view: SKView) {
//        // تعيين مندوب الفيزياء
//        physicsWorld.contactDelegate = self
//
//        // البحث عن اللاعب في المشهد
//        player = childNode(withName: "player") as? SKSpriteNode
//        
//        // التأكد أن اللاعب موجود
//        guard let player = player else { return }
//
//        // ضبط الفيزياء للاعب
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.categoryBitMask = 1
//        player.physicsBody?.contactTestBitMask = 2 // يتفاعل مع العشب والحجارة
//        player.physicsBody?.collisionBitMask = 2 // يصطدم بالعوائق
//
//        // إعداد العوائق (العشب والحجارة)
//        enumerateChildNodes(withName: "obstacle") { node, _ in
//            if let obstacle = node as? SKSpriteNode {
//                obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//                obstacle.physicsBody?.isDynamic = false // يجعلها ثابتة
//                obstacle.physicsBody?.categoryBitMask = 2 // تعريفها كعوائق
//            }
//        }
//
//        // حركة اللاعب التلقائية ذهابًا وإيابًا
//        let moveRight = SKAction.moveBy(x: 500, y: 0, duration: 5)
//        let sequence = SKAction.sequence([moveRight])
//        let repeatForever = SKAction.repeatForever(sequence)
//        player.run(repeatForever)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let player = player else { return }
//        if player.physicsBody?.velocity.dy == 0 {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 380))
//        }
//    }
//
//    // تنفيذ حدث عند التصادم
//    func didBegin(_ contact: SKPhysicsContact) {
//        let bodyA = contact.bodyA
//        let bodyB = contact.bodyB
//        
//        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2) ||
//           (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1) {
//            gameOver() // إنهاء اللعبة عند التصادم
//        }
//    }
//
//    func gameOver() {
//        player.removeAllActions() // إيقاف حركة اللاعب
//        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // إيقافه تمامًا
//        print("Game Over!") // يمكنك استبداله بشاشة نهاية اللعبة
//    }
//}












//
//
//import SpriteKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    var player: SKSpriteNode!
//    var cameraNode: SKCameraNode!
//    var obstacles: [SKSpriteNode] = []
//    
//    let playerCategory: UInt32 = 0x1 << 0
//    let obstacleCategory: UInt32 = 0x1 << 1
//    
//    override func didMove(to view: SKView) {
//        // البحث عن اللاعب والعقبات الموجودة في `GameScene.sks`
//        player = childNode(withName: "player") as? SKSpriteNode
//        obstacles = self.children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "grass" || $0.name == "rock" }
//        
//        guard let player = player else { return }
//        
//        // إعداد الفيزياء
//        physicsWorld.contactDelegate = self
//        
//        // إعداد اللاعب
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.categoryBitMask = playerCategory
//        player.physicsBody?.contactTestBitMask = obstacleCategory
//        player.physicsBody?.collisionBitMask = obstacleCategory
//        
//        // جعل العقبات غير متحركة ولكن لها فيزياء
//        for obstacle in obstacles {
//            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//            obstacle.physicsBody?.isDynamic = false
//            obstacle.physicsBody?.categoryBitMask = obstacleCategory
//        }
//        
//        // حركة اللاعب المستمرة للأمام
//        let moveForward = SKAction.moveBy(x: 500, y: 0, duration: 5)
//        let repeatForever = SKAction.repeatForever(moveForward)
//        player.run(repeatForever)
//        
//        // إضافة كاميرا تتبع اللاعب
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        // جعل الكاميرا تتبع اللاعب
//        cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
//        
//        // تحديث مواقع العقبات لإعادة استخدامها
//        for obstacle in obstacles {
//            if obstacle.position.x < player.position.x - 600 { // إذا خرجت من الشاشة
//                repositionObstacle(obstacle)
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let player = player else { return }
//        
//        // السماح بالقفز فقط إذا كان على الأرض
//        if player.physicsBody?.velocity.dy == 0 {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300)) // قفزة أعلى
//        }
//    }
//    
//    func repositionObstacle(_ obstacle: SKSpriteNode) {
//        let newX = player.position.x + CGFloat.random(in: 600...1000) // وضعها بعيدًا أمام اللاعب
//        obstacle.position.x = newX
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
//           (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
//            gameOver()
//        }
//    }
//    
//    func gameOver() {
//        print("💀 اللاعب مات!")
//        player.removeAllActions()
//        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//    }
//}





//
//
//import SpriteKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    var player: SKSpriteNode!
//    var cameraNode: SKCameraNode!
//    var obstacles: [SKSpriteNode] = []
//    var groundNodes: [SKSpriteNode] = []
//    
//    let playerCategory: UInt32 = 0x1 << 0
//    let obstacleCategory: UInt32 = 0x1 << 1
//    let groundCategory: UInt32 = 0x1 << 2
//    
//    override func didMove(to view: SKView) {
//        // البحث عن اللاعب
//        player = childNode(withName: "player") as? SKSpriteNode
//        guard let player = player else { return }
//        
//        // إعداد الفيزياء
//        physicsWorld.contactDelegate = self
//        
//        // إعداد اللاعب
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.categoryBitMask = playerCategory
//        player.physicsBody?.contactTestBitMask = obstacleCategory | groundCategory
//        player.physicsBody?.collisionBitMask = obstacleCategory | groundCategory
//        
//        // إعداد الأرضية المتكررة
//        setupGround()
//        
//        // إعداد العقبات
//        obstacles = self.children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "grass" || $0.name == "rock" }
//        for obstacle in obstacles {
//            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//            obstacle.physicsBody?.isDynamic = false
//            obstacle.physicsBody?.categoryBitMask = obstacleCategory
//        }
//        
//        // حركة اللاعب المستمرة للأمام
//        let moveForward = SKAction.moveBy(x: 500, y: 0, duration: 5)
//        let repeatForever = SKAction.repeatForever(moveForward)
//        player.run(repeatForever)
//        
//        // إضافة كاميرا تتبع اللاعب
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//    }
//    
//    func setupGround() {
//        // إيجاد الأرضية الأصلية
//        if let ground = childNode(withName: "ground") as? SKSpriteNode {
//            groundNodes.append(ground)
//            
//            // إنشاء نسخ إضافية للأرضية لضمان التكرار
//            for i in 1...2 {
//                let newGround = ground.copy() as! SKSpriteNode
//                newGround.position.x = ground.position.x + ground.size.width * CGFloat(i)
//                addChild(newGround)
//                groundNodes.append(newGround)
//            }
//            
//            // إضافة فيزياء للأرضية
//            for ground in groundNodes {
//                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//                ground.physicsBody?.isDynamic = false
//                ground.physicsBody?.categoryBitMask = groundCategory
//            }
//        }
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        // جعل الكاميرا تتبع اللاعب
//        cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
//        
//        // تحديث الأرضية لإبقائها متكررة
//        for ground in groundNodes {
//            if ground.position.x < player.position.x - ground.size.width {
//                ground.position.x += ground.size.width * CGFloat(groundNodes.count)
//            }
//        }
//        
//        // تحديث مواقع العقبات لإعادة استخدامها
//        for obstacle in obstacles {
//            if obstacle.position.x < player.position.x - 600 {
//                repositionObstacle(obstacle)
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let player = player else { return }
//        
//        // السماح بالقفز فقط إذا كان على الأرض
//        if player.physicsBody?.velocity.dy == 0 {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
//        }
//    }
//    
//    func repositionObstacle(_ obstacle: SKSpriteNode) {
//        let newX = player.position.x + CGFloat.random(in: 600...1000)
//        obstacle.position.x = newX
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
//           (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
//            gameOver()
//        }
//    }
//    
//    func gameOver() {
//        print("💀 اللاعب مات!")
//        player.removeAllActions()
//        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//    }
//}
//
//
//
//
//
//
////walk
//
//import SpriteKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    var player: SKSpriteNode!
//    var cameraNode: SKCameraNode!
//    var obstacles: [SKSpriteNode] = []
//    var groundNodes: [SKSpriteNode] = []
//    
//    let playerCategory: UInt32 = 0x1 << 0
//    let obstacleCategory: UInt32 = 0x1 << 1
//    let groundCategory: UInt32 = 0x1 << 2
//    
//    override func didMove(to view: SKView) {
//        setupPhysics()
//        setupPlayer()
//        setupGround()
//        setupObstacles()
//        setupCamera()
//    }
//    
//    func setupPhysics() {
//        physicsWorld.contactDelegate = self
//    }
//    
//    func setupPlayer() {
//        guard let player = childNode(withName: "player") as? SKSpriteNode else { return }
//        self.player = player
//        
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.categoryBitMask = playerCategory
//        player.physicsBody?.contactTestBitMask = obstacleCategory | groundCategory
//        player.physicsBody?.collisionBitMask = obstacleCategory | groundCategory
//        
//        let moveForward = SKAction.moveBy(x: 500, y: 0, duration: 5)
//        player.run(SKAction.repeatForever(moveForward))
//    }
//    
//    func setupGround() {
//        if let ground = childNode(withName: "ground") as? SKSpriteNode {
//            groundNodes.append(ground)
//            for i in 1...2 {
//                let newGround = ground.copy() as! SKSpriteNode
//                newGround.position.x = ground.position.x + ground.size.width * CGFloat(i)
//                addChild(newGround)
//                groundNodes.append(newGround)
//            }
//            
//            for ground in groundNodes {
//                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//                ground.physicsBody?.isDynamic = false
//                ground.physicsBody?.categoryBitMask = groundCategory
//            }
//        }
//    }
//    
//    func setupObstacles() {
//        obstacles = self.children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "grass" || $0.name == "rock" }
//        for obstacle in obstacles {
//            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//            obstacle.physicsBody?.isDynamic = false
//            obstacle.physicsBody?.categoryBitMask = obstacleCategory
//        }
//    }
//    
//    func setupCamera() {
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
//        updateGround()
//        updateObstacles()
//    }
//    
//    func updateGround() {
//        for ground in groundNodes {
//            if ground.position.x < player.position.x - ground.size.width {
//                ground.position.x += ground.size.width * CGFloat(groundNodes.count)
//            }
//        }
//    }
//    
//    func updateObstacles() {
//        for obstacle in obstacles {
//            if obstacle.position.x < player.position.x - 600 {
//                repositionObstacle(obstacle)
//            }
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if player.physicsBody?.velocity.dy == 0 {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
//        }
//    }
//    
//    func repositionObstacle(_ obstacle: SKSpriteNode) {
//        obstacle.position.x = player.position.x + CGFloat.random(in: 600...1000)
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
//           (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
//            gameOver()
//        }
//    }
//    
//    func gameOver() {
//        print("💀 اللاعب مات!")
//        player.removeAllActions()
//        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//    }
//}
//
//
//


//run run
////
//import SpriteKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    var player: SKSpriteNode!
//    var cameraNode: SKCameraNode!
//    var obstacles: [SKSpriteNode] = []
//    var groundNodes: [SKSpriteNode] = []
//    
//    let playerCategory: UInt32 = 0x1 << 0
//    let obstacleCategory: UInt32 = 0x1 << 1
//    let groundCategory: UInt32 = 0x1 << 2
//    
//    override func didMove(to view: SKView) {
//        // البحث عن اللاعب
//        player = childNode(withName: "player") as? SKSpriteNode
//        guard let player = player else { return }
//        
//        // إعداد الفيزياء
//        physicsWorld.contactDelegate = self
//        
//        // إعداد اللاعب
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.categoryBitMask = playerCategory
//        player.physicsBody?.contactTestBitMask = obstacleCategory | groundCategory
//        player.physicsBody?.collisionBitMask = obstacleCategory | groundCategory
//        
//        // تشغيل حركة الجري
//        startRunningAnimation()
//        
//        // إعداد الأرضية المتكررة
//        setupGround()
//        
//        // إعداد العقبات
//        obstacles = self.children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "grass" || $0.name == "rock" }
//        for obstacle in obstacles {
//            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//            obstacle.physicsBody?.isDynamic = false
//            obstacle.physicsBody?.categoryBitMask = obstacleCategory
//        }
//        
//        // حركة اللاعب المستمرة للأمام
//        let moveForward = SKAction.moveBy(x: 500, y: 0, duration: 5)
//        let repeatForever = SKAction.repeatForever(moveForward)
//        player.run(repeatForever)
//        
//        // إضافة كاميرا تتبع اللاعب
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//    }
//    
//    func startRunningAnimation() {
//        let texture1 = SKTexture(imageNamed: "run1.png")
//        let texture2 = SKTexture(imageNamed: "run2.png")
//        
//        let animation = SKAction.animate(with: [texture1, texture2], timePerFrame: 0.1)
//        let repeatAnimation = SKAction.repeatForever(animation)
//        
//        player.run(repeatAnimation)
//    }
//    
//    func setupGround() {
//        if let ground = childNode(withName: "ground") as? SKSpriteNode {
//            groundNodes.append(ground)
//            
//            for i in 1...2 {
//                let newGround = ground.copy() as! SKSpriteNode
//                newGround.position.x = ground.position.x + ground.size.width * CGFloat(i)
//                addChild(newGround)
//                groundNodes.append(newGround)
//            }
//            
//            for ground in groundNodes {
//                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//                ground.physicsBody?.isDynamic = false
//                ground.physicsBody?.categoryBitMask = groundCategory
//            }
//        }
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
//        
//        for ground in groundNodes {
//            if ground.position.x < player.position.x - ground.size.width {
//                ground.position.x += ground.size.width * CGFloat(groundNodes.count)
//            }
//        }
//        
//        for obstacle in obstacles {
//            if obstacle.position.x < player.position.x - 600 {
//                repositionObstacle(obstacle)
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let player = player else { return }
//        
//        if player.physicsBody?.velocity.dy == 0 {
//            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
//        }
//    }
//    
//    func repositionObstacle(_ obstacle: SKSpriteNode) {
//        let newX = player.position.x + CGFloat.random(in: 600...1000)
//        obstacle.position.x = newX
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
//           (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
//            gameOver()
//        }
//    }
//    
//    func gameOver() {
//        print("💀 اللاعب مات!")
//        player.removeAllActions()
//        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//    }
//}
//
//
//
//
//// run good
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var cameraNode: SKCameraNode!
    var obstacles: [SKSpriteNode] = []
    var groundNodes: [SKSpriteNode] = []
    var backgroundNodes: [SKSpriteNode] = [] // مصفوفة الخلفيات

    let playerCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player") as? SKSpriteNode
        guard let player = player else { return }
        
        physicsWorld.contactDelegate = self
        
        setupPlayer()
        startRunningAnimation()
        setupGround()
        setupObstacles()
        setupBackground() // إعداد الخلفية
        
        let moveForward = SKAction.moveBy(x: 500, y: 0, duration: 5)
        let repeatForever = SKAction.repeatForever(moveForward)
        player.run(repeatForever)
        
        setupCamera()
    }
    
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = obstacleCategory | groundCategory
        player.physicsBody?.collisionBitMask = obstacleCategory | groundCategory
    }
    
    func startRunningAnimation() {
        let texture1 = SKTexture(imageNamed: "run1.png")
        let texture2 = SKTexture(imageNamed: "run2.png")
        let texture3 = SKTexture(imageNamed: "run3.png")

        let animation = SKAction.animate(with: [texture1, texture2, texture3], timePerFrame: 0.1)
        let repeatAnimation = SKAction.repeatForever(animation)
        
        player.run(repeatAnimation)
    }
    
    func setupGround() {
        if let ground = childNode(withName: "ground") as? SKSpriteNode {
            groundNodes.append(ground)
            
            for i in 1...2 {
                let newGround = ground.copy() as! SKSpriteNode
                newGround.position.x = ground.position.x + ground.size.width * CGFloat(i)
                addChild(newGround)
                groundNodes.append(newGround)
            }
            
            for ground in groundNodes {
                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
                ground.physicsBody?.isDynamic = false
                ground.physicsBody?.categoryBitMask = groundCategory
            }
        }
    }
    
    func setupBackground() {
        if let background = childNode(withName: "background") as? SKSpriteNode {
            background.zPosition = -1
            background.size = CGSize(width: self.size.width * 1.4, height: self.size.height)  // تكبير الخلفية لتغطية الكاميرا

            backgroundNodes.append(background)
            
            for i in 1...2 {
                let newBackground = background.copy() as! SKSpriteNode
                newBackground.position.x = background.position.x + background.size.width * CGFloat(i)
                newBackground.zPosition = -1
                addChild(newBackground)
                backgroundNodes.append(newBackground)
            }
        }
    }
    
    func setupObstacles() {
        obstacles = self.children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "grass" || $0.name == "rock" }
        for obstacle in obstacles {
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = obstacleCategory
        }
    }
    
    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        if let player = player {
               cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
           }
    }
   
    
    
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = CGPoint(x: player.position.x + 200, y: 0)
        
        for ground in groundNodes {
            if ground.position.x < player.position.x - ground.size.width {
                ground.position.x += ground.size.width * CGFloat(groundNodes.count)
            }
        }

        for background in backgroundNodes {
            if background.position.x < player.position.x - background.size.width {
                background.position.x += background.size.width * CGFloat(backgroundNodes.count)
            }
        }
        
        for obstacle in obstacles {
            if obstacle.position.x < player.position.x - 600 {
                repositionObstacle(obstacle)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = player else { return }
        
        if player.physicsBody?.velocity.dy == 0 {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        }
    }
    
    func repositionObstacle(_ obstacle: SKSpriteNode) {
        let newX = player.position.x + CGFloat.random(in: 600...1000)
        obstacle.position.x = newX
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory) ||
           (contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == obstacleCategory) {
            gameOver()
        }
    }
    
    func gameOver() {
        print("💀 اللاعب مات!")
        player.removeAllActions()
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
}
