//
//  ItemView.swift
//  DisplayBuilder
//
//  A Layer Stack Item's View
//

import SwiftUI

struct ItemView: View {
    @ObservedObject var element: LCDStructureNode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(element.name ?? "Unknown component")
                    .bold()
                    .font(.monospaced(.title2)())
                    .foregroundStyle(.linearGradient(Gradient(colors: [.red, .purple]), startPoint: .leading, endPoint: .trailing))
                Spacer()
            }
            Stepper (value: $element.thickness, in: element.minimumThickness...10, step: 0.1, onEditingChanged: {_ in
                if Int(element.thickness) == 1 && tutorial.pageNumber == 8 && (tutorial.pageNumber == tutorial.maxPageNumber) {
                    // completed the step
                    tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                    tutorial.pageNumber += 1 // go to the next page
                }
            }) {
                    Text("Thickness: \(element.thickness, specifier: "%.1f") mm")
                        .font(.monospaced(.body)())
            }
            Text("Part No.: \(element.productNumber)")
                .font(.monospaced(.footnote)())
                .padding(.top)
        }
    }
}
