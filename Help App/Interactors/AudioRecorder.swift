//
//  AudioRecorder.swift
//  Help App
//
//  Created by Artem Rakhmanov on 14/03/2023.
//

import Foundation
import AVFoundation

//https://github.com/pinlunhuang/Voice-Recorder/blob/master/Voice%20Recorder/AudioRecorder.swift
class AudioRecorder {
    
    init(session: String) {
        self.session = session
    }
    
    var audioRecorder: AVAudioRecorder!
    let session: String //bundles recordings for display based on session
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sessionFolder = documentPath.appendingPathComponent(session)
        print("session folder: " + sessionFolder.path())
        do {
            try FileManager.default.createDirectory(atPath: sessionFolder.path(), withIntermediateDirectories: true)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        let audioFilename = sessionFolder.appendingPathComponent(Date().toString(dateFormat: "dd-MM-YY 'at' HH_mm_ss") + ".m4a")
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        
        //if less than 2 seconds - delete
    }
    
    func getSessionRecordings() -> [URL] {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sessionFolder = documentPath.appendingPathComponent(session)
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: sessionFolder, includingPropertiesForKeys: nil) {
            print(directoryContents)
            return directoryContents
        } else {
            print("no recordings for sesh")
            return []
        }
    }
}
