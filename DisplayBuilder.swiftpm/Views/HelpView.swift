//
//  HelpView.swift
//  DisplayBuilder
//
//  The Help Sheet Vieq that conatins the blueprint & controls info
//

import SwiftUI

struct HelpView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Hello, engineer!")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    isPresented.toggle()
                    if tutorial.pageNumber == 10 && (tutorial.pageNumber == tutorial.maxPageNumber) {
                        // completed the tutorial step
                        tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                        tutorial.pageNumber += 1 // go to the next page
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                })
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Image("LCDstructure")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("Welcome to Display Builder!")
                            .font(.title3)
                            .bold()
                            .padding()
                    Text("Display builder is simulator game in which you can learn about the structure of Liquid Crystal Displays (commonly known as LCDs) and different aspects of them.")
                    Group {
                        Text("Controls")
                                .font(.title3)
                                .bold()
                                .padding()
                        HStack {
                            Image(systemName: "lightbulb")
                                .font(.title)
                                .padding()
                            Text("Tip: you can always come back to this page by clicking the \(Image(systemName: "questionmark.circle")) help button in the bottom left corner.")
                        }
                        HStack {
                            Image(systemName: "list.bullet")
                                .font(.title)
                                .padding()
                            Text("Press the Levels button to select another level. If you choose anything other than Free Mode, you will see the Level's requirements under the Display Builder title.")
                        }
                    }
                    Group {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .padding()
                            Text("The run (play) button runs the display configuration check. This is the last thing you'll have to do in order to finish a level.")
                        }
                        HStack {
                            Image(systemName: "character.cursor.ibeam")
                                .font(.title)
                                .padding()
                            Text("Under the Display Builder title, there are some text inputs for your display's resolution (number of pixels) and size.")
                        }
                        HStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding()
                            Text("The plus button adds a new layer. Choose any items you want from the sheet that appears on the screen.")
                        }
                        HStack {
                            Image(systemName: "minus")
                                .font(.title)
                                .padding()
                            Text("The minus button removes the last item placed on the Layer Stack.")
                        }
                        HStack {
                            Image(systemName: "ruler.fill")
                                .font(.title)
                                .padding()
                            Text("Control each layer's thickness by pressing on the thickness control buttons (\(Image(systemName: "minus")) \(Image(systemName: "plus"))).")
                        }
                        HStack {
                            Image(systemName: "cursorarrow.and.square.on.square.dashed")
                                .font(.title)
                                .padding()
                            Text("Click and drag the layers in the Layer Preview to move them around (their order will not be changed). Accidental movements are ignored. Zoom in and zoom out using the slider in the bottom left corner, under the Layer Stack.")
                        }
                        HStack {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title)
                                .padding()
                            Text("Zoom in or zoom out of the Layer Preview by using the slider in the bottom left corner.")
                        }
                        HStack {
                            Image(systemName: "cube.transparent.fill")
                                .font(.title)
                                .padding()
                            Text("After running the display check and successfully passing it, you will see a 3D preview of your display.")
                        }
                    }
                    Text("Have fun! 🙂")
                        .font(.title)
                        .padding()
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(.linearGradient(Gradient(colors: [.purple, .blue, .cyan]), startPoint: .leading, endPoint: .bottom))
    }
}
