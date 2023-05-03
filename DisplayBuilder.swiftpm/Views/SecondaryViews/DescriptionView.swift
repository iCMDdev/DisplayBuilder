//
//  DescriptionView.swift
//  DisplayBuilder
//
//  This view shows the Display's Specifications
//

import SwiftUI

struct DescriptionView: View {
    @State var type: String
    @State var widthRes: Int
    @State var heightRes: Int
    @State var ppi: Int
    @State var thickness: Float
    @State var glass: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Display Specs")
                .font(.monospaced(.title)())
                .bold()
                .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .bottom))
                .padding(.bottom, 2)
            Text("Type: \(type)\nResolution: \(widthRes)x\(heightRes)\nGlass: \(glass)\nPPI: \(ppi)\nContrast ratio: \((type == "LCD") ? "1000:1" : "1 000 000:1") \nThickness: \(thickness, specifier: "%.1f")mm")
                .font(.monospaced(.body)())
                
        }
        
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(type: "Mini-LED LCD", widthRes: 1920, heightRes: 1080, ppi: 330, thickness: 1.2, glass: "Standard glass")
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
