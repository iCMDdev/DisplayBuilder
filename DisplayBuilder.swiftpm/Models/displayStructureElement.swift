//
//  displayStructureElement.swift
//  DisplayBulder
//
//  SpriteKit Layer
//

import SpriteKit

enum StructureElement {
    case backlight
    case tftArray
    case liquidCrystal
    case polarizer
    case glass
    case none
}

typealias Milimeters = Float

class LCDStructureNode: SKSpriteNode, ObservableObject, Identifiable {
    // the SpriteKit layer node type
    
    
    // drag movement feature - this allows the movement of layers in the spritekit view by dragging them
    // fast, accidental movements are automatically dismissed by this design
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.scale(to: CGSize(width: 50, height: 50), duration: 0.25))
        guard let touch = touches.first else {return}
        self.run(SKAction.move(to: touch.location(in: scene!), duration: 0.25))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        self.run(SKAction.move(to: touch.location(in: scene!), duration: 0.1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.scale(to: CGSize(width: 100, height: 100), duration: 0.25))
    }
    
    
    // class representing every display's element
    var id: UUID = UUID()
    var productNumber: UUID = UUID()
    let type: StructureElement
    let minimumThickness: Milimeters
    let info: String
    @Published var thickness: Milimeters
    
    init(name: String, info: String, texture: SKTexture?, color: UIColor, size: CGSize, type: StructureElement, thickness: Milimeters) {
        self.type = type
        self.thickness = thickness
        self.minimumThickness = thickness
        self.info = info
        super.init(texture: texture, color: color, size: size) // Initialising the parent class, SKSpriteNode
        super.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// LCDStructureNode Children (layer types):
let miniLedBacklight = LCDStructureNode(name: "Mini-LED Backlight", info: "The Mini-LED Backlight is a backlight that can turn off specific LEDs. The Mini-LED Backlight can provide higher contrast and true blacks, since Liquid Crystals don't turn fully opaque.", texture: nil, color: .white, size: CGSize(width: 100, height: 100), type: .backlight, thickness: 1.1)
let backlight = LCDStructureNode(name: "Standard LED Backlight", info: "The backlight lights up the display. It sits at the back of your display and its light goes through different layers.", texture: nil, color: .white, size: CGSize(width: 100, height: 100), type: .backlight, thickness: 0.5)
let tftArray = LCDStructureNode(name: "TFT Array", info: "The Thin-Film Transistor Array is a transparent film that controls the Liquid Crystals by providing them with more or less electrical current. Transistors are electrical circuit parts that act like a switch.", texture: SKTexture(imageNamed: "tftArray"), color: .clear, size: CGSize(width: 100, height: 100), type: .tftArray, thickness: 0.2)
let liquidCrystal = LCDStructureNode(name: "Liquid Crystal Array", info: "The Liquid Crystals are transparent, but they turn almost fully opaque when enough current is applied. They are used to diminish the light provided by the backlight. In front of the liquid crystals, there is a color filter that transforms the light into red, green and blue light. Using these 3 colors, almost any color cam be formed.", texture: SKTexture(imageNamed: "colorFilter"), color: .clear, size: CGSize(width: 100, height: 100), type: .liquidCrystal, thickness: 0.1)
let polarizer = LCDStructureNode(name: "Polarizer", info: "The polarizer is a layer that blocks specific light wavelengths. They are required in order to produce visbile images.", texture: SKTexture(imageNamed: "polarizer"), color: .clear, size: CGSize(width: 100, height: 100), type: .polarizer, thickness: 0.1)
let glass = LCDStructureNode(name: "Standard Glass", info: "Standard, reflective glass.", texture: SKTexture(imageNamed: "glass"), color: .clear, size: CGSize(width: 100, height: 100), type: .glass, thickness: 0.3)
let lowReflectiveGlass = LCDStructureNode(name: "Low-reflective Glass", info: "Low-reflective Glass is an inovative glass that is useful in many environments with uncontrolled lighting.", texture: SKTexture(imageNamed: "glass"), color: .clear, size: CGSize(width: 100, height: 100), type: .glass, thickness: 0.4)

// array that stores the layer types
let elements = [backlight, miniLedBacklight, tftArray, liquidCrystal, polarizer, glass, lowReflectiveGlass]
