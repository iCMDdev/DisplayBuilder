//
//  RunEngine.swift
//  DisplayBuilder
//
//  The app's engine. Collection of functions inside the Run class that check the Display built by the user.
//

import Darwin
import Foundation

var run: Run = Run(minResolutionWidth: nil, maxResolutionWidth: nil, minResolutionHeight: nil, maxResolutionHeight: nil, minPPI: nil, maxPPI: nil, minWidth: nil, maxWidth: nil, minHeight: nil, maxHeight: nil, minThickness: nil, maxThickness: nil, miniled: nil, reflectiveGlass: nil)
        
class Run {
    
    // Level requirements
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
    
    let requirements: Requirements
    
    
    init(minResolutionWidth: Int?, maxResolutionWidth: Int?, minResolutionHeight: Int?, maxResolutionHeight: Int?, minPPI: Int?, maxPPI: Int?, minWidth: Int?, maxWidth: Int?, minHeight: Int?, maxHeight: Int?, minThickness: Float?, maxThickness: Float?, miniled: Bool?, reflectiveGlass: Bool?) {
        requirements = Requirements(minResolutionWidth: minResolutionWidth, maxResolutionWidth: maxResolutionWidth, minResolutionHeight: minResolutionHeight, maxResolutionHeight: maxResolutionHeight, minPPI: minPPI, maxPPI: maxPPI, minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, minThickness: minThickness, maxThickness: maxThickness, miniled: miniled, reflectiveGlass: reflectiveGlass)
    }
    
    var debugString: String = ""
    
    func checkRatios() -> Bool {
        // function that checks if the display's ratio defined by the size in cm is the same as the one defined by the number of pixels
        // it uses approximation
        
        if (Double(build.widthResolution)/Double(build.heightResolution) - Double(build.sizeWidth)/Double(build.sizeHeight)) >= 0 && Double(build.widthResolution)/Double(build.heightResolution) - Double(build.sizeWidth)/Double(build.sizeHeight) <= 0.5 {
            return true
        } else if (Double(build.widthResolution)/Double(build.heightResolution) - Double(build.sizeWidth)/Double(build.sizeHeight)) < 0 && Double(build.widthResolution)/Double(build.heightResolution) - Double(build.sizeWidth)/Double(build.sizeHeight) > -0.5 {
            return true
        }
        
        return false
    }
    
    func thickness() -> Float {
        var value: Float = 0
        for i in 0..<build.stack.endIndex {
            value += build.stack[i].thickness
        }
        return value
    }
    
    func backlightType() -> String {
        let type: String
        var i: Int = 0
        while build.stack[i].type == .glass && i < build.stack.endIndex {
            i += 1
        }
        if build.stack[i].name == nil {
            type = "LCD"
        } else if build.stack[i].name == miniLedBacklight.name {
            type = "Mini-LED LCD"
        } else {
            type = "LCD"
        }
        
        return type
    }
    
    func glassType() -> String {
        guard let glassNode = build.stack.last else {
            return "none"
        }
        if glassNode.type != .glass {
            return "none"
        }
        guard let glassName = glassNode.name else {
            return "Glass"
        }
        return glassName
    }
    
    func findIndex(currentIndex: Int) -> Int {
        var i = currentIndex
        while currentIndex < build.stack.endIndex && build.stack[currentIndex].type == .glass {
            i += 1
        }
        return i
    }
    
    func ppiCalculator() {
        // this function calculates the created display's diagonal in inches and pixels using the Pitagorean theorem,
        // and then calculates the display's Pixels Per Inch (PPI) by dividing the 2 diagoal values.
        
        let inchWidth = Double(build.sizeWidth)*0.39371
        let inchHeight = Double(build.sizeHeight)*0.39371
        let diagonalInch = sqrt(Double(inchWidth*inchWidth + inchHeight*inchHeight))
        if diagonalInch == 0 {
            build.ppi = 0
        } else {
            let diagonalPixels = sqrt(Double(build.widthResolution*build.widthResolution + build.heightResolution*build.heightResolution))
            build.ppi = Int(diagonalPixels/diagonalInch)
        }
    }
    
    func checkLCD() -> Bool {
        // this function checks if the "Layer Stack" represents a fully working LCD
        // that is in accordance with the requirements
        
        let LCD: [StructureElement] = [.backlight, .polarizer, .tftArray, .none, .liquidCrystal, .polarizer]
        var LCDindex: Int = 0
        
        for i in 0..<build.stack.endIndex {
            if build.stack[i].type != .glass {
                if LCDindex >= 6 {
                    if build.stack[i].type != .glass {
                        return false
                    }
                }
                if(LCD[LCDindex] == .none) {
                    LCDindex += 1
                }
                if build.stack[i].type != LCD[LCDindex] {
                    return false
                }
                LCDindex += 1
            } else if build.stack[i].type == .glass && LCDindex < 6 && LCD[LCDindex] == .none  {
                return false
            }
        }
        if LCDindex == 6 {
            return true
        }
        return false
    }
    
    
    
    func runCheck() -> Bool {
        // the main function used to check the display
        
        run.debugString = ""
        
        if checkRatios() == false {
            debugString = "Dimensions Error: Display aspect ratios (cm and pixels) do not match."
            return false
        }
        
        if checkLCD() == false {
            debugString = "Structure Error: Display's layers are not placed correctly."
            return false
        }
        ppiCalculator()
        
        if (backlightType() == "LCD" && requirements.miniled == true) || (backlightType() == "Mini-LED LCD" && requirements.miniled == false) {
            debugString = "Requirements Error: wrong LCD backlight type."
            return false
        }
        
        if glassType() == "none" {
            debugString = "Structure Error: no outer glass."
            return false
        }
        
        if requirements.reflectiveGlass == true && glassType() != "Standard Glass" {
            debugString = "Requirements Error: wrong outer glass type."
            return false
        }
        
        if requirements.reflectiveGlass == false && glassType() != "Low-reflective Glass" {
            debugString = "Requirements Error: wrong outer glass type."
            return false
        }
        
        if requirements.minThickness != nil && thickness() < requirements.minThickness! {
            debugString = "Requirements Error: display too thin: \(thickness()) (minimum thickness requirement not respected)."
            return false
        }
        
        if requirements.maxThickness != nil && thickness() > requirements.maxThickness! {
            debugString = "Requirements Error: display too thick (maximum thickness requirement not respected)."
            return false
        }
        
        if (requirements.minResolutionWidth != nil) && (requirements.minResolutionWidth! > build.widthResolution) {
            debugString = "Requirements Error: minimum resolution width requirement not respected."
            return false
        }
        if (requirements.maxResolutionWidth != nil) && (requirements.maxResolutionWidth! < build.widthResolution) {
            debugString = "Requirements Error: maximum resolution width requirement not respected."
            return false
        }
        if (requirements.minResolutionHeight != nil) && (requirements.minResolutionHeight! > build.heightResolution) {
            debugString = "Requirements Error: minimum resolution height requirement not respected."
            return false
        }
        if (requirements.maxResolutionHeight != nil) && (requirements.maxResolutionHeight! < build.heightResolution) {
            debugString = "Requirements Error: maximum resolution height requirement not respected."
            return false
        }
        if (requirements.minPPI != nil) && (requirements.minPPI! > build.ppi) {
            debugString = "Requirements Error: minimum PPI requirement not respected."
            return false
        }
        if (requirements.maxPPI != nil) && (requirements.maxPPI! < build.ppi) {
            debugString = "Requirements Error: maximum PPI requirement not respected."
            return false
        }
        if (requirements.minWidth != nil) && (requirements.minWidth! > build.sizeWidth) {
            debugString = "Requirements Error: minimum width requirement not respected."
            return false
        }
        if (requirements.maxWidth != nil) && (requirements.maxWidth! < build.sizeWidth) {
            debugString = "Requirements Error: maximum width requirement not respected."
            return false
        }
        if (requirements.minHeight != nil) && (requirements.minHeight! > build.sizeHeight) {
            debugString = "Requirements Error: minimum height requirement not respected."
            return false
        }
        if (requirements.maxHeight != nil) && (requirements.maxHeight! < build.sizeHeight) {
            debugString = "Requirements Error: maximum height requirement not respected."
            return false
        }
        return true
    }
}
