import SpriteKit
import GameplayKit

class afterPlayButton: SKScene {
    
    override func didMove(to view: SKView) {
        // التحقق من أن العقدة Diriyah موجودة وتحديد اسمها
        if let buttonhNode = self.childNode(withName: "button") as? SKSpriteNode {
            buttonhNode.name = "button" // تأكد من أن الاسم مطابق في الـ SKScene
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        // التحقق إذا كان النقر على عقدة Diriyah
        if touchedNode.name == "button" {
            goToLoading()
        }
    }
    
    func goToLoading() {
        if let scene = SKScene(fileNamed: "Loading") { // تأكد من أن اسم المشهد مطابق في Xcode
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene) // بدون أي تأثير انتقال
        }
    }
}
