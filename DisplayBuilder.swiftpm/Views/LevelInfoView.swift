//
//  LevelInfo.swift
//  DisplayBuilder
//
//  View that displays Level information.
//

import SwiftUI

struct LevelInfo: View {
    @Binding var isPresented: Bool
    @State var levelID: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(levels[levelID].name)
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    isPresented.toggle()
                    loadLevelRequirements(requirements: levels[levelID].requirements)
                    currentLevel.index = levelID
                } label: {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                }

            }
                .padding(.bottom)
            
            Text(levels[levelID].description)
            Divider()
                .background(.white)
            Text("Level requirements:")
                .font(.title2)
                .padding(.bottom)
            if levelID == 0 {
                Text("The Free Mode does not have any requirements other than creating a working LCD display by using the blueprint.\nIt is mandatory to place an outer glass layer.")
                    .font(.monospaced(.body)())
            } else {
                Group {
                    
                    if levels[levelID].requirements.miniled != nil {
                        Text("Backlight: \(levels[levelID].requirements.miniled! ? "Mini-LED backlight" : "Standard backlight")")
                    }
                    
                    if levels[levelID].requirements.reflectiveGlass != nil {
                        Text("Glass: \(levels[levelID].requirements.reflectiveGlass! ? "Standard glass" : "Low-reflective glass")")
                    }
                    
                    if levels[levelID].requirements.minResolutionWidth != nil && levels[levelID].requirements.maxResolutionWidth == levels[levelID].requirements.minResolutionWidth && levels[levelID].requirements.minResolutionHeight != nil && levels[levelID].requirements.maxResolutionHeight == levels[levelID].requirements.minResolutionHeight {
                        Text("Resolution: \(levels[levelID].requirements.minResolutionWidth!)x\(levels[levelID].requirements.minResolutionHeight!)")
                    } else if levels[levelID].requirements.minResolutionWidth != nil && levels[levelID].requirements.minResolutionHeight != nil && levels[levelID].requirements.maxResolutionWidth == nil && levels[levelID].requirements.maxResolutionHeight == nil {
                        Text("Min resolution: \(levels[levelID].requirements.minResolutionWidth!)x\(levels[levelID].requirements.minResolutionHeight!)")
                    } else if levels[levelID].requirements.maxResolutionWidth != nil && levels[levelID].requirements.maxResolutionHeight != nil && levels[levelID].requirements.minResolutionWidth == nil && levels[levelID].requirements.minResolutionHeight == nil {
                        Text("Max resolution: \(levels[levelID].requirements.maxResolutionWidth!)x\(levels[levelID].requirements.maxResolutionHeight!)")
                    } else {
                        if levels[levelID].requirements.minResolutionWidth != nil && levels[levelID].requirements.maxResolutionWidth == levels[levelID].requirements.minResolutionWidth {
                            Text("Resolution width: \(levels[levelID].requirements.minResolutionWidth!)cm")
                        } else if levels[levelID].requirements.minResolutionWidth != nil {
                            Text("Minimum resolution width: \(levels[levelID].requirements.minResolutionWidth!)cm")
                        } else if levels[levelID].requirements.maxResolutionWidth != nil {
                            Text("Maximum resolution width: \(levels[levelID].requirements.maxResolutionWidth!)cm")
                        }
                        if levels[levelID].requirements.minResolutionHeight != nil && levels[levelID].requirements.maxResolutionHeight == levels[levelID].requirements.minResolutionHeight {
                            Text("Resolution height: \(levels[levelID].requirements.minResolutionHeight!)cm")
                        } else if levels[levelID].requirements.minResolutionHeight != nil {
                            Text("Minimum resolution height: \(levels[levelID].requirements.minResolutionHeight!)cm")
                        } else if levels[levelID].requirements.maxResolutionWidth != nil {
                            Text("Maximum resolution height: \(levels[levelID].requirements.maxResolutionHeight!)cm")
                        }
                    }
                    if levels[levelID].requirements.minWidth != nil && levels[levelID].requirements.maxWidth == levels[levelID].requirements.minWidth {
                        Text("Width: \(levels[levelID].requirements.minWidth!)cm")
                    } else {
                        if levels[levelID].requirements.minWidth != nil {
                            Text("Minimum width: \(levels[levelID].requirements.minWidth!)cm")
                        }
                        if levels[levelID].requirements.maxWidth != nil {
                            Text("Maximum width: \(levels[levelID].requirements.maxWidth!)cm")
                        }
                    }
                    if levels[levelID].requirements.minHeight != nil && levels[levelID].requirements.maxHeight == levels[levelID].requirements.minHeight {
                            Text("Height: \(levels[levelID].requirements.minHeight!)cm")
                    } else {
                        if levels[levelID].requirements.minHeight != nil {
                            Text("Minimum height: \(levels[levelID].requirements.minHeight!)cm")
                        }
                        if levels[levelID].requirements.maxHeight != nil {
                            Text("Maximum height: \(levels[levelID].requirements.maxHeight!)cm")
                        }
                    }
                    if levels[levelID].requirements.minThickness != nil && levels[levelID].requirements.maxThickness == levels[levelID].requirements.minThickness {
                        Text("Thickness: \(levels[levelID].requirements.minThickness!, specifier: "%.1f")mm")
                    } else {
                        if levels[levelID].requirements.minThickness != nil {
                            Text("Minimum thickness: \(levels[levelID].requirements.minThickness!, specifier: "%.1f")mm")
                        }
                        if levels[levelID].requirements.maxThickness != nil {
                            Text("Maximum thickness: \(levels[levelID].requirements.maxThickness!, specifier: "%.1f")mm")
                        }
                    }
                    
                    if levels[levelID].requirements.minPPI != nil && levels[levelID].requirements.maxPPI == levels[levelID].requirements.minPPI {
                        Text("PPI: \(levels[levelID].requirements.minPPI!)")
                    } else {
                        if levels[levelID].requirements.minPPI != nil {
                            Text("Minimum PPI: \(levels[levelID].requirements.minPPI!)")
                        }
                        if levels[levelID].requirements.maxPPI != nil {
                            Text("Maximum PPI: \(levels[levelID].requirements.maxPPI!)")
                        }
                    }
                }
                .font(.monospaced(.body)())
            }
            HStack {
                Image(systemName: "lightbulb")
                    .font(.title)
                    .padding()
                Text("Tip: You can access the blueprint at any time by pressing the \(Image(systemName: "questionmark.circle")) help button.")
            }
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .background(.linearGradient(Gradient(colors: [Color(red: levels[levelID].color1_Red, green: levels[levelID].color1_Green, blue: levels[levelID].color1_Blue), Color(red: levels[levelID].color2_Red, green: levels[levelID].color2_Green, blue: levels[levelID].color2_Blue)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
