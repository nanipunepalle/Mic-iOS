//
//  AudioPlayer.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    var audioPlayer: AVAudioPlayer!
    
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startPlayback (audio: URL) {
        
//        let playbackSession = AVAudioSession.sharedInstance()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
        
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    
}
