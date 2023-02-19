//
//  EmailAvailability.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

struct EmailAvailability: Codable, ResponseModel {
    let emailIsAvailable: Bool
}
