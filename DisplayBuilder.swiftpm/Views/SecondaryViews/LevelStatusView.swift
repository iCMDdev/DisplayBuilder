//
//  LevelStatusView.swift
//  DisplayBuilder
//
//  View used by RunView to show the status of a level (Pass / Denied)
//

import SwiftUI

struct LevelStatusView: View {
    @Binding var isPresented: Bool
    @Binding var levelsArePresented: Bool
    @State var pass: Bool
    var body: some View {
        HStack {
            if (tutorial.pageNumber <= 16) && ((tutorial.pageNumber == tutorial.maxPageNumber) || (tutorial.pageNumber == 15 && tutorial.maxPageNumber == 16))  && pass == true {
                // if the user is in the tutorial and passed the level
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .bottom))
                    .font(.custom("SF-Pro", size: 100))
                VStack {
                    Text("Pass")
                        .padding(.bottom)
                        .foregroundStyle(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                        .font(.custom("Menlo-Regular", size: 50))
                    Text("Congrats! Your display received approval!")
                        .padding(.horizontal)
                        .font(.custom("Menlo-Regular", size: 20))
                    Button(action: {
                        // completed the tutorial step
                        if tutorial.pageNumber == 16 {
                            tutorial.pageNumber = 16 // update View
                            tutorial.messages[tutorial.pageNumber] = Text("Congratulations! You created your own LCD.")
                            tutorial.memoji[tutorial.pageNumber] = "memojiCelebration"
                            tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                        } else {
                            tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                            tutorial.pageNumber += 1 // go to the next page
                            tutorial.messages[tutorial.pageNumber] = Text("Congratulations! You created your own LCD.")
                            tutorial.memoji[tutorial.pageNumber] = "memojiCelebration"
                            tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                        }
                        isPresented.toggle()
                    }, label: {
                        Text("< Close window >")
                            .font(.custom("Menlo-Regular", size: 20))
                            .padding(.top)
                    })
                }
            } else if (tutorial.pageNumber <= 16) && ((tutorial.pageNumber == tutorial.maxPageNumber) || (tutorial.pageNumber == 15 && tutorial.maxPageNumber == 16))  && pass == false {
                // if the user is in the tutorial and didn't pass the level
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(LinearGradient(colors: [.red, Color(red: 1, green: 0, blue: 0.7, opacity: 1)], startPoint: .leading, endPoint: .bottom))
                    .font(.custom("SF-Pro", size: 100))
                VStack {
                    Text("Denied")
                        .padding(.bottom)
                        .foregroundStyle(LinearGradient(colors: [.red, Color(red: 1, green: 0, blue: 0.5, opacity: 1)], startPoint: .leading, endPoint: .bottom))
                        .font(.custom("Menlo-Regular", size: 50))
                    Text("Oh no! Your display did not pass the requirements.")
                        .padding(.horizontal)
                        .font(.custom("Menlo-Regular", size: 20))
                    Button(action: {
                        if tutorial.pageNumber != 16
                        {
                            tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                            tutorial.pageNumber += 1 // go to the next page
                        }
                        tutorial.pageNumber = 16 // update view
                        tutorial.messages[tutorial.pageNumber] = Text("Something is wrong with your display layer structure. Find the error and correct it, then press the \(Image(systemName: "play.fill")) run button again.")
                        tutorial.memoji[tutorial.pageNumber] = "memojiMac"
                        isPresented.toggle()
                    }, label: {
                        Text("< Back to building >")
                            .font(.custom("Menlo-Regular", size: 20))
                            .padding(.top)
                    })
                }
            } else if pass == true {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .bottom))
                    .font(.custom("SF-Pro", size: 100))
                VStack {
                    Text("Pass")
                        .padding(.bottom)
                        .foregroundStyle(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                        .font(.custom("Menlo-Regular", size: 50))
                    Text("Congrats! Your display received approval!")
                        .padding(.horizontal)
                        .font(.custom("Menlo-Regular", size: 20))
                    Button(action: {
                        isPresented.toggle()
                        if tutorial.allowMenu {
                            levelsArePresented.toggle()
                        }
                    }, label: {
                        if tutorial.allowMenu {
                            Text("< Main menu >")
                                .font(.custom("Menlo-Regular", size: 20))
                                .padding(.top)
                        } else {
                            Text("< Close window >")
                                .font(.custom("Menlo-Regular", size: 20))
                                .padding(.top)
                        }
                            
                    })
                }
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(LinearGradient(colors: [.red, Color(red: 1, green: 0, blue: 0.7, opacity: 1)], startPoint: .leading, endPoint: .bottom))
                    .font(.custom("SF-Pro", size: 100))
                VStack {
                    Text("Denied")
                        .padding(.bottom)
                        .foregroundStyle(LinearGradient(colors: [.red, Color(red: 1, green: 0, blue: 0.5, opacity: 1)], startPoint: .leading, endPoint: .bottom))
                        .font(.custom("Menlo-Regular", size: 50))
                    Text("Oh no! Your display did not pass the requirements.")
                        .padding(.horizontal)
                        .font(.custom("Menlo-Regular", size: 20))
                    Button(action: {isPresented.toggle()}, label: {
                        Text("< Back to building >")
                            .font(.custom("Menlo-Regular", size: 20))
                            .padding(.top)
                    })
                }
            }
            
        }
    }
}


