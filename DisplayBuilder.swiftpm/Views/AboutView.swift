//
//  AboutView.swift
//  DisplayBuilder
//
//  This is the About View. It includes the Legal Notices
//

import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool
    @State private var showLegal: Bool = false
    
    func readLegal() -> String {
        var file = Bundle.main.url(forResource: "LICENSE", withExtension: "txt")
        var data: Data
        var string: String = ""
        do {
            string += "Source code level JSON parser function:\n"
            data = try Data(contentsOf: file!)
            string += String(data: data, encoding: .utf8)!
            string += "Original code can be found here:\nhttps://developer.apple.com/tutorials/swiftui/building-lists-and-navigation\n\n"
        } catch {
            print("error reading JSON license")
        }
        
        do {
            file = Bundle.main.url(forResource: "IMAGES-LICENSE", withExtension: "txt")
            string += "Images:\n"
            data = try Data(contentsOf: file!)
            string += String(data: data, encoding: .utf8)!
        } catch {
            print("error reading IMAGES license")
        }
        
        return string
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                })
            }
            .padding(.vertical)
            Spacer()
            Group {
                Group {
                    HStack {
                        Image("DisplayBuilder")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 10)
                        Text("Display Builder")
                            .font(.title)
                            .bold()
                            .shadow(color: .gray, radius: 10)
                    }
                    Text("Developed by CMD.")
                        .font(.headline)
                        .padding(.bottom, 1)
                    Text("Version 1.0 for Swift Student Challenge")
                        .font(.footnote)
                        .padding(.bottom, 1)
                    Text("A simple educational app that teaches the LCD's structure by building your own display.")
                        .font(.footnote)
                        .padding(.bottom)
                }
                .animation(.spring(), value: showLegal)
                Button(action: {showLegal.toggle()}) {
                    Text("\(showLegal ? "Hide" : "Show") Legal Notices")
                        .animation(.spring(), value: showLegal)
                }
                if showLegal  {
                    HStack {
                        Text("Legal Notices:")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(readLegal())
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
