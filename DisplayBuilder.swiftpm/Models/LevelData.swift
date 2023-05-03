//
//  LevelData.swift
//  DisplayBuilder
//
//  Level structure + level loader function
//

import Foundation
import UIKit

class CurrentLevel: ObservableObject {
    // observable object used to indicate a level's ID and update the Views that depend on this
    @Published var index: Int? = nil
}
var currentLevel = CurrentLevel()   // variable that indicates the current level
var levels: [Level] = loadLevelsFromJSON()

func loadLevelRequirements(requirements: Level.Requirements) {
    run = Run(minResolutionWidth: requirements.minResolutionWidth, maxResolutionWidth: requirements.maxResolutionWidth, minResolutionHeight: requirements.minResolutionHeight, maxResolutionHeight: requirements.maxResolutionHeight, minPPI: requirements.minPPI, maxPPI: requirements.maxPPI, minWidth: requirements.minWidth, maxWidth: requirements.maxWidth, minHeight: requirements.minHeight, maxHeight: requirements.maxHeight, minThickness: requirements.minThickness, maxThickness: requirements.maxThickness, miniled: requirements.miniled, reflectiveGlass: requirements.reflectiveGlass)
}

struct Level: Identifiable, Decodable {
    var id: Int
    let name: String
    let description: String
    let color1_Red: Double
    let color1_Green: Double
    let color1_Blue: Double
    let color2_Red: Double
    let color2_Green: Double
    let color2_Blue: Double
    var completed: Bool
    let requirements: Requirements
    
    struct Requirements: Decodable {
        let minResolutionWidth: Int?
        let maxResolutionWidth: Int?
        let minResolutionHeight: Int?
        let maxResolutionHeight: Int?
        let minPPI: Int?
        let maxPPI: Int?
        let minWidth: Int?
        let maxWidth: Int?
        let minHeight: Int?
        let maxHeight: Int?
        let minThickness: Float?
        let maxThickness: Float?
        let miniled: Bool?
        let reflectiveGlass: Bool?
        init(minResolutionWidth: Int?, maxResolutionWidth: Int?, minResolutionHeight: Int?, maxResolutionHeight: Int?, minPPI: Int?, maxPPI: Int?, minWidth: Int?, maxWidth: Int?, minHeight: Int?, maxHeight: Int?, minThickness: Float?, maxThickness: Float?, miniled: Bool?, reflectiveGlass: Bool?) {
            self.minResolutionWidth = minResolutionWidth
            self.maxResolutionWidth = maxResolutionWidth
            self.minResolutionHeight = minResolutionHeight
            self.maxResolutionHeight = maxResolutionHeight
            self.minPPI = minPPI
            self.maxPPI = maxPPI
            self.minWidth = minWidth
            self.maxWidth = maxWidth
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            self.minThickness = minThickness
            self.maxThickness = maxThickness
            self.miniled = miniled
            self.reflectiveGlass = reflectiveGlass
        }
    }
}

/*
    The following function (loadLevelsFromJSON<levelOutput: Decodable>() -> levelOutput) was borrowed from Apple's SwiftUI Landmarks App tutorial (changes were made), under the following license:
    -------------------------------------------------------------------
    Copyright © 2021 Apple Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    -------------------------------------------------------------------
 
    You can also check the license at the following location in the app's folder:
        licenses/jsonFunction/LICENSE.txt
 */

func loadLevelsFromJSON<levelOutput: Decodable>() -> levelOutput {
    // function to read data from levels.json (the file that contains the app's level details)
    
    let data: Data

    guard let file = Bundle.main.url(forResource: "levels", withExtension: "json") else {
        fatalError("Couldn't find levels.json in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load levels.json from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(levelOutput.self, from: data)
    } catch {
        fatalError("Couldn't parse levels.json as \(levelOutput.self):\n\(error)")
    }
}
