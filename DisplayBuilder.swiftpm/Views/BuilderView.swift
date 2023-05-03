//
//  BuilderView.swift
//  This is the main view used by the app.
//
//  It contains some composed SwiftUI Views on the left, containg the Layer Stack, and a SpriteKit View on the right (Layer Preview).
//

import SwiftUI
import SpriteKit

var startingPoint = CGPoint(x: 150, y: 150) // starting point for the layers in layer preview; it changes when a layer is added
let displayNode = SKNode()  // The layer images in the right side of the screen are children of this node.
let labelsNode = SKNode()   // Next to the layers, a SKLabelNode with their name is placed. All SKLabelNodes are children of the labelsNode
let cameraNode = SKCameraNode() // The SpriteKit camera, used for the zoom feature (zoom slider in the bottom left corner)

class BuilderScene: SKScene {
    override func didMove(to view: SKView) {
        // camera init
        cameraNode.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        camera = cameraNode
        
        // labelsNode init
        labelsNode.isUserInteractionEnabled = true
        addChild(labelsNode)
        
        // displayNode init
        displayNode.isUserInteractionEnabled = true // allow the user to move the items
        addChild(displayNode)
    }
}

var buildScene: BuilderScene {
    let scene = BuilderScene()
    // scene init:
    scene.size = CGSize(width: 600, height: 600)
    scene.scaleMode = .aspectFill
    scene.backgroundColor = .clear
    scene.view?.allowsTransparency = true
    scene.view?.backgroundColor = .clear
    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    return scene
}

func cameraZoom(value: Double) {
    // function that zooms in / zooms out the SpriteKit View
    let zoomAction = SKAction.scale(to: value, duration: 0.25)
    cameraNode.run(zoomAction)
}

func addOnStack(element: LCDStructureNode) {
    // this function adds an element on the Layer Stack
    
    // The Layer Stack is represented by an array of elements (build.stack)
    // to which new layers are appended and old ones are removed.
    
    // The build.names array stores the layer names on the same principle.
    
    build.stack.append(LCDStructureNode(name: element.name ?? "Unknown component", info: element.info, texture: element.texture, color: element.color, size: element.size, type: element.type, thickness: element.thickness))
    build.stack.last?.productNumber = element.productNumber
    build.stack.last?.isUserInteractionEnabled = true
    build.stack.last?.position = startingPoint
    
    // label creation
    let text = SKLabelNode(fontNamed: "Menlo-Regular")
    text.text = element.name
    text.fontColor = .systemGray
    text.fontSize = 11
    text.position = CGPoint(x: startingPoint.x - 150, y: startingPoint.y+30)
    labelsNode.addChild(text)
    build.names.append(text)
    if startingPoint.x > -150 {
        // play the layer lower if it is in the view
        startingPoint = CGPoint(x: startingPoint.x-25, y: startingPoint.y-25)
    }
    displayNode.addChild(build.stack.last!)
}

func removeFromStack() {
    // this function removes an element from the Layer Stack
    
    build.stack.last?.removeFromParent()
    build.names.last?.removeFromParent()
    if startingPoint.x < 150 {
        startingPoint = CGPoint(x: startingPoint.x+25, y: startingPoint.y+25)
    }
    if build.stack.isEmpty == false {
        build.stack.removeLast()
        build.names.removeLast()
    }
}

class BuilderStack: ObservableObject {
    // a class that contains important values
    // used by the Layer Stack (previously named Builder Stack), Layer Preview and RunEngine
    
    @Published var stack: [LCDStructureNode] = []   // Array used to store the Layer Stack elements
    @Published var names: [SKLabelNode] = []        // Array used to store the Layer Stack elements' names
    @Published var widthResolution: Int = 0         // Width in pixels
    @Published var heightResolution: Int = 0        // Height in pixels
    var sizeWidth: Int = 0                          // Width in cm
    var sizeHeight: Int = 0                         // Height in cm
    @Published var ppi: Int = 0                     // Pixel per inch
}

var build = BuilderStack()  // the variable used for the reasons mentioned above, in the BuilderStack class definition

enum Fields: Hashable {
    // enumeration used for the TextField focus
    case sizeWidth, sizeHeight
    case widthResolution, heightResolution
}



struct BuilderView: View {
    
    // View-related variables:
    @State private var helpSheet: Bool = false          // help sheet
    @State private var showElements: Bool = false       // layer picker view
    @State private var runTest: Bool = false            // run view
    @State private var showLevels: Bool = false         // level menu
    
    // Display size TextFields-related
    @State private var widthResolution: String = ""
    @State private var heightResolution: String = ""
    @State private var sizeWidth: String = ""
    @State private var sizeHeight: String = ""
    
    @State private var fieldWarning: Bool = false // used to show the warning message
    @State private var showFieldWarning: [Bool] = [false, false, false, false]  // used for the red background on the TextFields when
    @FocusState private var fieldFocus: Fields? // used for the field focus when the value entered cannot be converted to an Int
    
    // SpriteKit zoom feature
    @State private var zoomVal: Double = 5
    @State private var zoom: Double = 1
    
    
    @ObservedObject var tutorialInfo = tutorial     // updates the view as the user steps trough the tutorial
    @ObservedObject var buildStack = build          // updates the view when an item is added on the Layer Stack
    @ObservedObject var loadedLevel = currentLevel  // updates the view when the level is changed
    
    func isInputOkay() -> Bool {
        // function that verifies if the TextField inputs contain integers only and warns the user
        
        let fields = [sizeWidth, sizeHeight, widthResolution, heightResolution]
        for i in 0..<4 {
            showFieldWarning[i] = (Int(fields[i]) == nil)
        }
        fieldWarning = true
        if showFieldWarning[0] {
            fieldFocus = .sizeWidth
            return false
        } else if showFieldWarning[1] {
            fieldFocus = .sizeHeight
            return false
        } else if showFieldWarning[2] {
            fieldFocus = .widthResolution
            return false
        } else if showFieldWarning[3] {
            fieldFocus = .heightResolution
            return false
        } else {
            fieldWarning = false
        }
        return true
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Display Builder")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing))
                        Spacer()
                        Button(action: {
                            if tutorialInfo.allowRun {
                                // when the button is clicked,
                                // run the display check only if it is allowed by the tutorial
                                if isInputOkay() { // if the TextField inputs are Int values
                                    
                                    // save dimensions
                                    build.sizeWidth = Int(sizeWidth)!
                                    build.sizeHeight = Int(sizeHeight)!
                                    build.widthResolution = Int(widthResolution)!
                                    build.heightResolution = Int(heightResolution)!
                                    
                                    // run test
                                    runTest.toggle()
                                    if run.runCheck() {
                                        // mark level as completed if the level is passed
                                        levels[loadedLevel.index ?? 0].completed = true
                                    }
                                }
                            }
                        })
                        {
                            Image(systemName: "play.fill")
                                .font(.largeTitle)
                                .foregroundStyle(LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing))
                        }
                        .sheet(isPresented: $runTest) {
                            RunView(isPresented: $runTest, levelsArePresented: $showLevels, pass: run.runCheck())
                                .interactiveDismissDisabled(tutorialInfo.maxPageNumber <= 16)
                        }
                    }
                    .padding()
                    if levels[loadedLevel.index ?? 0].name != "Free mode" {
                        VStack(alignment: .leading) {
                            
                            // level reuirements (shown only if the user is not in Free Mode
                            
                            Text("Requirements:")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .bold()
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(levels[loadedLevel.index ?? 0].name)
                                            .bold()
                                        Spacer()
                                    }
                                    if levels[loadedLevel.index ?? 0].requirements.miniled != nil {
                                        Text("\(levels[loadedLevel.index ?? 0].requirements.miniled! ? "Mini-LED backlight" : "Standard backlight")")
                                    }
                                    
                                    if levels[loadedLevel.index ?? 0].requirements.reflectiveGlass != nil {
                                        Text("\(levels[loadedLevel.index ?? 0].requirements.reflectiveGlass! ? "Standard glass" : "Low-reflective glass")")
                                    }
                                    
                                    // the idea of the following lines of code:
                                    // if the minimum and maximum requirement value match, they are not shown separately;
                                    // instead they are shown as a single value
                                    
                                    if levels[loadedLevel.index ?? 0].requirements.minResolutionWidth != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth == levels[loadedLevel.index ?? 0].requirements.minResolutionWidth && levels[loadedLevel.index ?? 0].requirements.minResolutionHeight != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight == levels[loadedLevel.index ?? 0].requirements.minResolutionHeight {
                                        Text("Resolution: \(levels[loadedLevel.index ?? 0].requirements.minResolutionWidth!)x\(levels[loadedLevel.index ?? 0].requirements.minResolutionHeight!)")
                                    } else if levels[loadedLevel.index ?? 0].requirements.minResolutionWidth != nil && levels[loadedLevel.index ?? 0].requirements.minResolutionHeight != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth == nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight == nil {
                                        Text("Min resolution: \(levels[loadedLevel.index ?? 0].requirements.minResolutionWidth!)x\(levels[loadedLevel.index ?? 0].requirements.minResolutionHeight!)")
                                    } else if levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight != nil && levels[loadedLevel.index ?? 0].requirements.minResolutionWidth == nil && levels[loadedLevel.index ?? 0].requirements.minResolutionHeight == nil {
                                        Text("Max resolution: \(levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth!)x\(levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight!)")
                                    } else {
                                        if levels[loadedLevel.index ?? 0].requirements.minResolutionWidth != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth == levels[loadedLevel.index ?? 0].requirements.minResolutionWidth {
                                            Text("Resolution width: \(levels[loadedLevel.index ?? 0].requirements.minResolutionWidth!)cm")
                                        } else if levels[loadedLevel.index ?? 0].requirements.minResolutionWidth != nil {
                                            Text("Minimum resolution width: \(levels[loadedLevel.index ?? 0].requirements.minResolutionWidth!)cm")
                                        } else if levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth != nil {
                                            Text("Maximum resolution width: \(levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth!)cm")
                                        }
                                        if levels[loadedLevel.index ?? 0].requirements.minResolutionHeight != nil && levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight == levels[loadedLevel.index ?? 0].requirements.minResolutionHeight {
                                            Text("Resolution height: \(levels[loadedLevel.index ?? 0].requirements.minResolutionHeight!)cm")
                                        } else if levels[loadedLevel.index ?? 0].requirements.minResolutionHeight != nil {
                                            Text("Minimum resolution height: \(levels[loadedLevel.index ?? 0].requirements.minResolutionHeight!)cm")
                                        } else if levels[loadedLevel.index ?? 0].requirements.maxResolutionWidth != nil {
                                            Text("Maximum resolution height: \(levels[loadedLevel.index ?? 0].requirements.maxResolutionHeight!)cm")
                                        }
                                    }
                                    if levels[loadedLevel.index ?? 0].requirements.minWidth != nil && levels[loadedLevel.index ?? 0].requirements.maxWidth == levels[loadedLevel.index ?? 0].requirements.minWidth {
                                        Text("Width: \(levels[loadedLevel.index ?? 0].requirements.minWidth!)cm")
                                    } else {
                                        if levels[loadedLevel.index ?? 0].requirements.minWidth != nil {
                                            Text("Minimum width: \(levels[loadedLevel.index ?? 0].requirements.minWidth!)cm")
                                        }
                                        if levels[loadedLevel.index ?? 0].requirements.maxWidth != nil {
                                            Text("Maximum width: \(levels[loadedLevel.index ?? 0].requirements.maxWidth!)cm")
                                        }
                                    }
                                    if levels[loadedLevel.index ?? 0].requirements.minHeight != nil && levels[loadedLevel.index ?? 0].requirements.maxHeight == levels[loadedLevel.index ?? 0].requirements.minHeight {
                                            Text("Height: \(levels[loadedLevel.index ?? 0].requirements.minHeight!)cm")
                                    } else {
                                        if levels[loadedLevel.index ?? 0].requirements.minHeight != nil {
                                            Text("Minimum height: \(levels[loadedLevel.index ?? 0].requirements.minHeight!)cm")
                                        }
                                        if levels[loadedLevel.index ?? 0].requirements.maxHeight != nil {
                                            Text("Maximum height: \(levels[loadedLevel.index ?? 0].requirements.maxHeight!)cm")
                                        }
                                    }
                                    if levels[loadedLevel.index ?? 0].requirements.minThickness != nil && levels[loadedLevel.index ?? 0].requirements.maxThickness == levels[loadedLevel.index ?? 0].requirements.minThickness {
                                        Text("Thickness: \(levels[loadedLevel.index ?? 0].requirements.minThickness!, specifier: "%.1f")mm")
                                    } else {
                                        if levels[loadedLevel.index ?? 0].requirements.minThickness != nil {
                                            Text("Minimum thickness: \(levels[loadedLevel.index ?? 0].requirements.minThickness!, specifier: "%.1f")mm")
                                        }
                                        if levels[loadedLevel.index ?? 0].requirements.maxThickness != nil {
                                            Text("Maximum thickness: \(levels[loadedLevel.index ?? 0].requirements.maxThickness!, specifier: "%.1f")mm")
                                        }
                                    }
                                    
                                    if levels[loadedLevel.index ?? 0].requirements.minPPI != nil && levels[loadedLevel.index ?? 0].requirements.maxPPI == levels[loadedLevel.index ?? 0].requirements.minPPI {
                                        Text("PPI: \(levels[loadedLevel.index ?? 0].requirements.minPPI!)")
                                    } else {
                                        if levels[loadedLevel.index ?? 0].requirements.minPPI != nil {
                                            Text("Minimum PPI: \(levels[loadedLevel.index ?? 0].requirements.minPPI!)")
                                        }
                                        if levels[loadedLevel.index ?? 0].requirements.maxPPI != nil {
                                            Text("Maximum PPI: \(levels[loadedLevel.index ?? 0].requirements.maxPPI!)")
                                        }
                                    }
                                }
                                .font(.monospaced(.body)())
                                .foregroundStyle(.gray)
                            }
                           
                        }
                        .frame(width: 250, height: 140)
                        .padding()
                    }
                    HStack {
                        Text("Size (cm):")
                        TextField(" width", text: $sizeWidth)
                            .focused($fieldFocus, equals: Fields.sizeWidth)
                            .frame(width: 50)
                            .padding(2)
                            .background(showFieldWarning[0] ? Color(red: 0.75, green: 0, blue: 0, opacity: 0.25) : Color(red: 0.35, green: 0.35, blue: 0.35, opacity: 0.15))
                            .cornerRadius(5)
                        Text("x")
                        TextField("height", text: $sizeHeight)
                            .focused($fieldFocus, equals: Fields.sizeHeight)
                            .frame(width: 50)
                            .padding(2)
                            .background(showFieldWarning[1] ? Color(red: 0.75, green: 0, blue: 0, opacity: 0.25) : Color(red: 0.35, green: 0.35, blue: 0.35, opacity: 0.15))
                            .cornerRadius(5)
                    }
                    .padding(.horizontal)
                    HStack {
                        Text("Resolution:")
                        TextField(" width", text: $widthResolution)
                            .focused($fieldFocus, equals: Fields.widthResolution)
                            .frame(width: 50)
                            .padding(2)
                            .background(showFieldWarning[2] ? Color(red: 0.75, green: 0, blue: 0, opacity: 0.25) : Color(red: 0.35, green: 0.35, blue: 0.35, opacity: 0.15))
                            .cornerRadius(5)
                        Text("x")
                        TextField("height", text: $heightResolution)
                            .focused($fieldFocus, equals: Fields.heightResolution)
                            .frame(width: 50)
                            .padding(2)
                            .background(showFieldWarning[3] ? Color(red: 0.75, green: 0, blue: 0, opacity: 0.25) : Color(red: 0.35, green: 0.35, blue: 0.35, opacity: 0.15))
                            .cornerRadius(5)
                    }
                    .padding(.horizontal)
                    if fieldWarning {
                        Text("Please type correct integer number values.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    Divider()
                    HStack {
                        Image(systemName: "square.stack.3d.up.fill")
                            .padding()
                            .foregroundStyle(.linearGradient(Gradient(colors: [.red, .purple]), startPoint: .bottom, endPoint: .top))
                        Text("Layer Stack")
                            .bold()
                            
                        Spacer()
                        Button(action: {
                            if tutorialInfo.allowStackRemove {
                                removeFromStack()
                            }
                            if tutorial.pageNumber == 11 && (tutorial.pageNumber == tutorial.maxPageNumber) {
                                // completed the tutorial step
                                tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                                tutorial.pageNumber += 1 // go to the next page
                            }
                        }) {
                            Image(systemName: "minus")
                        }
                        .padding()
                        Button(action: {
                            if tutorialInfo.allowStackAdd {
                                showElements.toggle()
                            }
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .sheet(isPresented: $showElements) {
                            ItemsPickerView(isPresented: $showElements)
                        }.padding()
                    }
                    ScrollView {
                        ForEach(buildStack.stack) { element in
                            ItemView(element: element)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                        }
                        Spacer()
                    }
                    HStack {
                        Button(action: {
                            // when the button is clicked,
                            // show the level menu only if it is allowed by the tutorial
                            if tutorialInfo.allowMenu {
                                showLevels.toggle()
                            }
                            
                        }, label: {
                            Image(systemName: "list.bullet")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .padding()
                        })
                        Button(action: {
                            // when the button is clicked,
                            // show the help sheet only if it is allowed by the tutorial
                            if tutorialInfo.allowHelp {
                                helpSheet.toggle()
                            }
                        }, label: {
                            Image(systemName: "questionmark.circle")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .padding()
                        })
                        .sheet(isPresented: $helpSheet, onDismiss: {
                            if tutorial.pageNumber == 10 && (tutorial.pageNumber == tutorial.maxPageNumber) {
                                // completed the tutorial step
                                tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                                tutorial.pageNumber += 1 // go to the next page
                            }
                        }, content: {HelpView(isPresented: $helpSheet)})
                        Slider(value: Binding(  // slider for Layer View zoom in / zoom out
                            get: {
                                zoom
                            },
                            set: {(newValue) in
                                zoom = newValue
                                cameraZoom(value: 1.75-zoom)
                            }
                        ), in: 0.25...1.75)
                            .padding()
                            .tint(.gray)
                    }
                }
                .frame(width: 300)
                .padding()
                Spacer()
                SpriteView(scene: buildScene, options: [.allowsTransparency])
                    .background(.ultraThickMaterial)
                //.scaledToFit()
            }
        }
        .sheet(isPresented: $showLevels) {
            MenuView(isPresented: $showLevels)
        }
    }
}
