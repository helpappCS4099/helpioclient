//
//  RepositoryResponse.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

enum RepositoryResponse {
    case success(status: Int,
                 model: ResponseModel? = nil,
                 errorMessage: String? = nil)
    case failure(status: Int,
                 body: ResponseModel? = nil,
                 errorMessage: String? = nil)
}

extension RepositoryResponse: WebRequestResultProtocol {
    var status: Int {
        switch self {
        case .success(let status, _, _):
            return status
        case .failure(let status, _, _):
            return status
        }
    }
    
    var model: ResponseModel? {
        switch self {
        case .success(_, let model, _):
            return model
        case .failure(_, let model, _):
            return model
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .success(_, _, let errorMessage):
            return errorMessage
        case .failure(_, _, let errorMessage):
            return errorMessage
        }
    }
}
