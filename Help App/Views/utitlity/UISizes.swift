//
//  UISizes.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import Foundation
import SwiftUI

let bounds = UIScreen.main.bounds

let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }

    let deviceMapping = [
                         "iPhone8,1": "iPhone 6s",
                         "iPhone8,2": "iPhone 6s Plus",
                         "iPhone9,1": "iPhone 7",
                         "iPhone9,3": "iPhone 7",
                         "iPhone9,2": "iPhone 7 Plus",
                         "iPhone9,4": "iPhone 7 Plus",
                         "iPhone8,4": "iPhone SE",
                         "iPhone10,1": "iPhone 8",
                         "iPhone10,4": "iPhone 8",
                         "iPhone10,2": "iPhone 8 Plus",
                         "iPhone10,5": "iPhone 8 Plus",
                         "iPhone10,3": "iPhone X",
                         "iPhone10,6": "iPhone X",
                         "iPhone11,2": "iPhone XS",
                         "iPhone11,4": "iPhone XS Max",
                         "iPhone11,6": "iPhone XS Max",
                         "iPhone11,8": "iPhone XR",
                         "iPhone12,1": "iPhone 11",
                         "iPhone12,3": "iPhone 11 Pro",
                         "iPhone12,5": "iPhone 11 Pro Max",
                         "iPhone12,8" : "iPhone SE 2nd Gen",
                         "iPhone13,1" : "iPhone 12 Mini",
                         "iPhone13,2" : "iPhone 12",
                         "iPhone13,3" : "iPhone 12 Pro",
                         "iPhone13,4" : "iPhone 12 Pro Max",
                         "iPhone14,2" : "iPhone 13 Pro",
                         "iPhone14,3" : "iPhone 13 Pro Max",
                         "iPhone14,4" : "iPhone 13 Mini",
                         "iPhone14,5" : "iPhone 13",
                         "iPhone14,6" : "iPhone SE 3rd Gen",
                         "iPhone14,7" : "iPhone 14",
                         "iPhone14,8" : "iPhone 14 Plus",
                         "iPhone15,2" : "iPhone 14 Pro",
                         "iPhone15,3" : "iPhone 14 Pro Max"
                         ]
    return deviceMapping[identifier] ?? identifier
}()

func isNotchedIphone() -> Bool {
    
    let notchedPhones = [
        "iPhone X", "iPhone XS", "iPhone XS Max", "iPhone XR", "iPhone 11", "iPhone 11 Pro",
        "iPhone 11 Pro",
        "iPhone 11 Pro",
        "iPhone 12 mini",
        "iPhone 12 Mini",
        "iPhone 12",
        "iPhone 12 Pro",
        "iPhone 12 Pro Max",
        "iPhone 13 Pro",
        "iPhone 13 Pro Max",
        "iPhone 13 Mini",
        "iPhone 13",
        "iPhone SE 3rd Gen",
        "iPhone 14",
        "iPhone 14 Plus",
        "iPhone 14 Pro",
        "iPhone 14 Pro Max"
    ]
    
    let currentModelName = modelName == "64 bit Simulator" ? UIDevice.current.name : modelName
    
    return notchedPhones.contains(currentModelName)
}
