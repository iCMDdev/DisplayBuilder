//
//  DisplaySceneView.swift
//  DisplayBuilder
//
//  This View displays the SceneKit view at the end of a level, when the level is passed.
//

import SwiftUI
import SceneKit

struct DisplaySceneView: View {
    @State var miniLed: Bool
    @State var lowReflectiveGlass: Bool
    
    var scene: SCNScene? {
        
        let scn = SCNScene(named: "DisplayScene.scn")
        scn?.rootNode.childNode(withName: "box", recursively: false)?.scale = SCNVector3(Int(build.sizeWidth*10), Int(build.sizeHeight*10), Int(run.thickness()))
        let rotateAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 5)
        let repeatedAction = SCNAction.repeatForever(rotateAction)
        scn?.rootNode.childNode(withName: "box", recursively: false)?.runAction(repeatedAction, forKey: "displayRotation")
        scn?.rootNode.childNode(withName: "plane", recursively: true)?.geometry?.firstMaterial?.emission.contents = UIImage(named: "gradient.png")
        if miniLed == false {
            // if the display doesn't have a Mini-LED backlight
            // provide a lower contrast ratio and simulate a standard lcd by not providing a 'true black'
            scn?.rootNode.childNode(withName: "plane", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
        }
        if lowReflectiveGlass {
            // if it is a low-reflective glass
            // increase it's roughness (decrease reflectivity)
            scn?.rootNode.childNode(withName: "plane", recursively: true)?.geometry?.firstMaterial?.roughness.intensity = 1
        }
        return scn
    }

    var body: some View {
        SceneView(
            scene: scene,
            pointOfView: scene?.rootNode.childNode(withName: "camera", recursively: false),
            options: [
                .allowsCameraControl,
                .autoenablesDefaultLighting
            ]
        )
    }
}
