//
//  Listview.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import SwiftUI

struct Listview: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                HStack {
                    Text("\(recording.fileURL.lastPathComponent)")
                    Spacer()
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: recording.fileURL)
                        }) {
                            Image(systemName: "play.circle")
                                .imageScale(.large)
                        }
                    } else {
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                        }) {
                            Image(systemName: "stop.fill")
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
    }
}

struct Listview_Previews: PreviewProvider {
    static var previews: some View {
        Listview(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}
