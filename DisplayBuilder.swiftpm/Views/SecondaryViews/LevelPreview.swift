//
//  LevelPreview.swift
//  DisplayBuilder
//
//  Previews a level: level title, description and completion status
//

import SwiftUI

struct LevelPreview: View {
    @State var title: String
    @State var description: String
    @State var gradient: Gradient
    @State var completed: Bool
    
    var body: some View {
        HStack {
            if completed {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Text(description)
                    .multilineTextAlignment(.leading)
            }
            Image(systemName: "chevron.right")
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(.linearGradient(gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct LevelPreview_Previews: PreviewProvider {
    static var previews: some View {
        LevelPreview(title: "Mini-LED Display", description: "Description goes here.", gradient: Gradient(colors: [.cyan, .pink]), completed: true)
    }
}
