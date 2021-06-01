//
//  MicApp.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import SwiftUI

@main
struct MicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecorder: AudioRecorder(numberOfSamples: 10))
        }
    }
}
