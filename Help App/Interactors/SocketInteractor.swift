//
//  SocketInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 26/03/2023.
//

import Foundation
import SocketIO

//handle all events here and reply in a callback
final class SocketInteractor {
    
    static let standard = SocketInteractor()
    
    var manager: SocketManager?
    var socket: SocketIOClient?
    var authPayload: [String: String] = [:]
    
    var onUpdate: (HelpRequestModel) -> Void = {_ in}
    var onClose: () -> Void = {}
    
    func openSocket(for helpRequestID: String) {
        
        guard let jwt = KeychainHelper.standard.read(service: "jwt", account: "helpapp"),
              let url = URL(string: BASEURLSTRING + "ws/helprequests/" + helpRequestID),
              let base = URL(string: "https://helpapp.loca.lt")
        else {
            print("no jwt")
            return
        }
        let authHeaderPayload: [String: String] = ["token": jwt]
        authPayload = authHeaderPayload
//        let manager = SocketManager(socketURL: url, config: [.log(true), .forcePolling(false), .forceWebsockets(true)])
        manager = SocketManager(socketURL: base, config: [.log(true), .secure(true)])
        socket = manager?.socket(forNamespace: "/ws/helprequests/" + helpRequestID)
        guard let socket = socket else {
            print("socket was nil")
            return
        }
        //handlers
        
        socket.on(clientEvent: .connect, callback: { [weak self] data, _ in
            print("connected", socket.nsp, self?.manager?.socketURL ?? "nil")
        })
        
        socket.on(clientEvent: .error) { data, _ in
            print("CHECK", data[0])
            self.onClose()
        }
        
        socket.on(clientEvent: .disconnect) { data, _ in
            print("disconnected")
        }
        
        socket.on(clientEvent: .reconnect) { data, _ in
            print("reconnected")
        }
        
        socket.on("update") { payload, _ in
            print("received update", payload)
            if let helpRequest = self.serializePayload(payload: payload[0], to: HelpRequestModel.self) {
                print("great success", type(of: helpRequest))
                self.onUpdate(helpRequest)
            }
        }
        
        socket.on("helprequest: close") { payload, _ in
            print("close!")
            let isRespondent = UserDefaults.standard.bool(forKey: "isRespondent")
            
            self.breakConnections()
            self.onClose()
            self.onClose = {}
        }
        
        socket.connect(withPayload: authHeaderPayload)
        
    }
    
    func resume() {
        if let socket = socket {
            socket.connect(withPayload: authPayload)
        }
    }
    
    func terminateConnections() {
        //close all socket connections
        if let socket = socket {
            socket.disconnect()
        }
    }
    
    
    //after resolution
    func breakConnections() {
        if let socket = socket {
            socket.disconnect()
        }
        socket = nil
        manager = nil
    }
    
    func serializePayload<T:Decodable>(payload: Any, to type: T.Type) -> T? {
        guard let jsonPayload = try? JSONSerialization.data(withJSONObject: payload) else {
            print("couldnt jsonize dict")
            return nil
        }
        guard let model = try? JSONDecoder().decode(type.self, from: jsonPayload) else {
            print("couldnt decode")
            return nil
        }
        return model
    }
    
}


//shared events
extension SocketInteractor {
    func pushLocation(longitude: Double, latitude: Double) {
        socket?.emit("helprequest: location", [
            "latitude": latitude,
            "longitude": longitude
        ])
    }
    
    func sendMessage(message: String) {
        socket?.emit("helprequest: message", ["message": message])
    }
}

//victim events
extension SocketInteractor {
    func resolveHelpRequest(onResolve: @escaping (Bool) -> Void) {
        socket?.emitWithAck("helprequest: resolve", [:]).timingOut(after: 0) { payload in
            //acknowledged
//            onResolve(payload["status"])
        }
    }
}

//respondent events
extension SocketInteractor {
    func acceptHelpRequest(userID: String, firstName: String) {
        socket?.emit("helprequest: accept", [
            "respondentID": userID,
            "firstName": firstName
        ])
    }
    
    func rejectHelpRequest(userID: String, firstName: String) {
        socket?.emit("helprequest: reject", [
            "respondentID": userID,
            "firstName": firstName
        ])
    }
    
    func sendOnTheWayStatus(userID: String, firstName: String) {
        socket?.emit("helprequest: ontheway", [
            "respondentID": userID,
            "firstName": firstName
        ])
    }
}
