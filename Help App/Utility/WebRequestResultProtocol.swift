//
//  WebRequestResultProtocol.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

protocol WebRequestResultProtocol {
    var status: Int { get }
    var model: ResponseModel? { get }
    var errorMessage: String? { get }
}
