//
//  DisplayCheckErrorView.swift
//  DisplayBuilder
//
//  View that shows the error in a user's Display configuration.
//

import SwiftUI

struct DisplayCheckErrorView: View {
    var body: some View {
        Text(run.debugString)
            .font(.monospaced(.body)())
    }
}

struct DisplayCheckErrorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayCheckErrorView()
    }
}
