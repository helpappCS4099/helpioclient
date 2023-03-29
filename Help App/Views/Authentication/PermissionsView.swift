//
//  PermissionsView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import SwiftUI
import CoreLocation
import AVFAudio

struct PermissionsDescriptionView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ForEach(PermissionDescription.allCases, id: \.title) { permission in
                permissionDescriptionRow(title: permission.title,
                                         description: permission.description,
                                         imgName: permission.imgName)
                .padding([.leading, .trailing])
            }
        }
    }
    
    func permissionDescriptionRow(title: String, description: String, imgName: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.body)
            }
            Spacer()
            
            Image(systemName: imgName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 60, height: 60)
        }
        .frame(maxWidth: .infinity)
    }
}

extension AuthRootView {
    
    func requestPermissions() async {
        do {
            
            //request normal notifications
            let notificationOptions: UNAuthorizationOptions = [.sound, .alert]
            let nc = UNUserNotificationCenter.current()
            let notificationsGranted = try await nc.requestAuthorization(options: notificationOptions)
            guard notificationsGranted == true else {
                //user alert
                throw "Permissions denied"
            }
            
            //request critical alerts
            let criticalOptions: UNAuthorizationOptions = [.sound, .alert, .criticalAlert]
            let criticalGranted = try await nc.requestAuthorization(options: criticalOptions)
            guard criticalGranted == true else {
                throw "Permissions denied"
            }
            
            //request mic
            let micGranted = await withCheckedContinuation({ (continuation: CheckedContinuation<Bool, Never>) in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            })
            guard micGranted == true else {
                throw "Permissions denied"
            }
            
            //check if location permission is given
            LocationTracker.standard.cl.requestAlwaysAuthorization()
            
            //get token to the server
            UIApplication.shared.registerForRemoteNotifications()
            
            
            
        } catch {
            //user alert
            showPermissionsAlert = true
            return
        }
    }
    
    func grantPermissions() -> some View {
        VStack {
            
        }
    }
}
