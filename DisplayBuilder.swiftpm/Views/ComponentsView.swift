//
//  ItemsPickerView.swift
//  DisplayBuilder
//
//  The view from which new display layers are picked. Accessed when the + button is pressed in BuilderView
//

import SwiftUI
import SpriteKit

struct ItemsPickerView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Available layers:")
                    .font(.title2)
                    .bold()
                .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                Spacer()
                Button(action: {isPresented.toggle()}, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                })
                
            }
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(elements, id: \.name) { element in
                        Button(action: {
                            if tutorial.maxPageNumber >= 12 {
                                addOnStack(element: element)
                                isPresented.toggle()
                            } else if tutorial.pageNumber == 7 && element.name == "Standard LED Backlight" && (tutorial.pageNumber == tutorial.maxPageNumber) {
                                addOnStack(element: element)
                                // completed the step
                                tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                                tutorial.pageNumber += 1 // go to the next page
                                isPresented.toggle()
                            } else if tutorial.pageNumber == 9 && element.name == "TFT Array" && (tutorial.pageNumber == tutorial.maxPageNumber) {
                                addOnStack(element: element)
                                // completed the step
                                tutorial.allowNextPage[tutorial.pageNumber] = true  // allow the user to navigate to and from this step
                                tutorial.pageNumber += 1 // go to the next page
                                isPresented.toggle()
                            }
                        }, label: {
                            VStack {
                                HStack {
                                    Text(element.name ?? "Unknown component")
                                        .font(.monospaced(.body)())
                                        .padding()
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "ruler")
                                        .foregroundColor(.gray)
                                    Text("min \(element.minimumThickness, specifier: "%.1f")mm")
                                        .font(.monospaced(.body)())
                                        .padding(.trailing)
                                        .foregroundColor(.gray)
                                }
                                Text(element.info)
                                    .multilineTextAlignment(.leading)
                                    .font(.monospaced(.body)())
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                        })
                    }
                }
            }
        }
        .padding()
    }
}
