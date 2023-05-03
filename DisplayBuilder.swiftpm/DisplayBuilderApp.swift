import SwiftUI

@main
struct DisplayBuilderApp: App {
    @State private var showAbout: Bool = false
    @ObservedObject private var tutorialInfo = tutorial
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topTrailing) {
                    BuilderView()
                    HStack {
                        // layer preview title
                        // music control button
                        // and app about button
                        
                        Text("Layer Preview")
                            .font(.title)
                            .bold()
                        Button(action: {showAbout.toggle()}) {
                            Image(systemName: "info.circle")
                        }
                        .font(.title)
                    .sheet(isPresented: $showAbout, content: {AboutView(isPresented: $showAbout)})
                    }
                    .padding()
                }
                if tutorialInfo.finished == false {
                    // bottom right corner tutorial View
                    TutorialView()
                        .cornerRadius(15)
                        .frame(width: 500, height: 100)
                        .padding()
                }
            }
        }
    }
}
