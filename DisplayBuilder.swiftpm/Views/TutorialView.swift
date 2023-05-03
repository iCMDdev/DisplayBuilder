//
//  TutorialView.swift
//  DisplayBuilder
//
//  Tutorial View & classes used by the tutorial
//

import SwiftUI

class Tutorial: ObservableObject {
    // the tutorial class
    
    func skipTutorial() {
        // function used to skip the tutorial
        pageNumber = messages.endIndex - 1
        finished = true
        allowStackAdd = true
        allowHelp = true
        allowStackRemove = true
        allowRun = true
    }
    
    var maxPageNumber: Int = 0
    @Published var pageNumber: Int {
        willSet(newValue) {
            if newValue == 2 {
                // on page 3, run the tutorial level (ID: 1) and load the level requirements
                loadLevelRequirements(requirements: levels[1].requirements)
                currentLevel.index = 1
            }
            
            // allow functionality when required:
            if newValue == 7 {
                allowStackAdd = true
            }
            
            if newValue == 10 {
                allowHelp = true
            }
            
            if newValue == 11 {
                allowStackRemove = true
            }
            
            if newValue == 15 {
                allowRun = true
            }
            
            if newValue == messages.endIndex - 1 {
                allowMenu = true
            }
            
            if newValue > maxPageNumber {
                maxPageNumber = newValue
            }
        }
    }      // the memoji window number
    @Published var finished: Bool = false   // this variable shows if the tutorial window was closed by the user at the end of the tutorial.
    
    // As the user goes through the tutorial, the following functionalities are unlocked:
    @Published var allowRun: Bool = false           // run the display check
    @Published var allowMenu: Bool = false          // open the level menu
    @Published var allowStackAdd: Bool = false      // allow adding layers to the Layer Stack
    @Published var allowStackRemove: Bool = false   // allow removing layers from the Layer Stack
    @Published var allowHelp: Bool = false          // open the help sheet
    
    // The messages that appear during the tutorial in the tutorial window
    var messages: [Text] = [Text("Hi there! I'm CMD, this app's developer."),
                            Text("Welcome to Display Builder! This app teaches you the structure of LCD displays in a fun way."),
                            Text("Let's get started by creating a display!"),
                            Text("On the left, you should see this level's requirements."),
                            Text("Use the requirements to enter the LCD's size and resolution in the inputs under them."),
                            Text("Good job!"),
                            Text("Under the inputs, you should see the Layer Stack. That's were you will see your display's layers."),
                            Text("Add a Standard LED backlight by clicking the \(Image(systemName: "plus")) button next to the Layer Stack title."),
                            Text("Great! Now change the thickness of this layer to 1 mm by using the \(Image(systemName: "minus")) \(Image(systemName: "plus")) stepper buttons."),
                            Text("Nice work! Now, just like you did with the backlight, add a TFT Array layer."),
                            Text("What else should we add? Press the \(Image(systemName: "questionmark.circle")) help button to check the blueprint. Close it when you're done."),
                            Text("Oops! It seems like we forgot to add a Polarizer. Press the \(Image(systemName: "minus")) button to remove the item placed on top of the Layer Stack."),
                            Text("Great! Now finish adding the other layers by using the blueprint."),
                            Text("Good job! While doing all of this, you might've noticed the layers appear on the right side of your screen."),
                            Text("This area is called the Layer Preview. You can drag the layers and place them the way you want."),
                            Text("I think we're finished. Let's check the display. Press the \(Image(systemName: "play.fill")) run button."),
                            Text("Congratulations! You created your own LCD."),
                            Text("The 3D preview of your display is based on your screen's dimensions, backlight and outer glass type. How cool is that?"),
                            Text("Thank you for using my app! You can check out other cool levels by clicking the \(Image(systemName: "list.bullet")) levels button.")]
    
    // The memoji images that appear during the tutorial
    var memoji: [String] = ["memojiHello", "memojiMac", "memojiMac", "memojiMac", "memojiMac", "memojiMac", "memojiMac", "memojiMac", "memojiGoodJob", "memojiWink", "memojiMac", "memojiMac", "memojiHappy", "memojiMac", "memojiWow", "memojiMac", "memojiCelebration", "memojiWow", "memojiMac"]
    
    // Next and Previous buttons for the tutorial:
    var allowNextPage: [Bool] = [true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, false, false, true, false]
    let allowPreviousPage: [Bool] = [false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
    
    // REGARDING THE PAGES AND PAGE NAVIGATION:
    
    // Note: In the following, a "step" means a page that doesn't have a next button
    // (except the last page) and requires the user to do something, like placing a layer.
    
    // The user is allowed to go trough the previous completed steps if they need.
    // Skipping a step isn't possible.
    // Skipping the whole tutorial at the beginning is possible though.
    
    init() {
        self.pageNumber = 0 // initialize page number
    }
}

let tutorial = Tutorial() // tutorial variable

struct TutorialView: View {
    @ObservedObject private var tutorialInfo = tutorial
    var body: some View {
        VStack {
           
            HStack {
                if tutorialInfo.allowPreviousPage[tutorialInfo.pageNumber] {
                    // if allowed, show the previous page chevron button
                    Button {
                        tutorialInfo.pageNumber -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                    }
                }
                Image(tutorialInfo.memoji[tutorialInfo.pageNumber]) // the memoji
                    .resizable()
                    .scaledToFit()
                VStack {
                    tutorialInfo.messages[tutorialInfo.pageNumber] // the message
                        .bold()
                    if tutorialInfo.pageNumber == 0 {
                        Button  {
                            tutorialInfo.skipTutorial()
                        } label: {
                            Text("Skip tutorial \(Image(systemName: "forward.fill"))")
                                .underline()
                        }
                    }
                }
                Spacer()
                if tutorialInfo.allowNextPage[tutorialInfo.pageNumber] {
                    // if allowed, show the next page chevron button
                    Button {
                        tutorialInfo.pageNumber += 1
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                    }
                } else if tutorialInfo.messages.endIndex == tutorialInfo.pageNumber + 1 {
                    // if it is the last page, show the close tutorial window button (xmark button)
                    Button {
                        tutorialInfo.finished = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                    }
                }
            }
        }
        .padding()
        .foregroundColor(.white)
    .background(.linearGradient(Gradient(colors: [Color(red: 0.05, green: 0.55, blue: 0.95, opacity: 0.75), Color(red: 0.15, green: 0, blue: 0.85, opacity: 0.75)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .previewLayout(.fixed(width: 400, height: 100))
            .cornerRadius(15)
    }
}
