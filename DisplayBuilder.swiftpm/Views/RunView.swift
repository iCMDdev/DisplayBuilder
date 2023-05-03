//
//  RunView.swift
//  DisplayBuilder
//
//  The View displayed when the user runs the display check
//

import SwiftUI

struct RunView: View {
    @Binding var isPresented: Bool
    @Binding var levelsArePresented: Bool
    @State var pass: Bool
    var body: some View {
        VStack {
            
            if pass == false {
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(.clear)
                    Image(systemName: "display.trianglebadge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(.clear)
                }
            } else {
                DisplaySceneView(miniLed: run.backlightType()=="Mini-LED LCD", lowReflectiveGlass: run.glassType()=="Low-reflective Glass")
            }
            HStack {
                LevelStatusView(isPresented: $isPresented, levelsArePresented: $levelsArePresented, pass: pass)
                    .padding(.bottom)
                if pass == true {
                    DescriptionView(type: run.backlightType(), widthRes: build.widthResolution, heightRes: build.heightResolution, ppi: build.ppi, thickness: run.thickness(), glass: run.glassType())
                            .padding()
                } else {
                    DisplayCheckErrorView()
                        .padding()
                }
            }
            .padding()
            
        }
        .background(.ultraThinMaterial)
    }
}


