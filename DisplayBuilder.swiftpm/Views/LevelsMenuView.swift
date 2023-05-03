//
//  MenuView.swift
//  DisplayBuilder
//
//  This view shows the available levels and is used to select one.
//

import SwiftUI

struct MenuView: View {
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(levels) { level in
                        NavigationLink(destination: LevelInfo(isPresented: $isPresented, levelID: level.id)) {
                            LevelPreview(title: level.name, description: level.description, gradient: Gradient(colors: [Color(red: level.color1_Red, green: level.color1_Green, blue: level.color1_Blue), Color(red: level.color2_Red, green: level.color2_Green, blue: level.color2_Blue)]), completed: level.completed)
                                .accentColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            .navigationTitle("Levels")
            }

        }
        .accentColor(.white)
    }
}
