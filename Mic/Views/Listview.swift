//
//  Listview.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import SwiftUI

struct Listview: View {
    @ObservedObject var audioRecorder: AudioRecorder
    //    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                
                ListRowView(recording: recording)
                    .animation(.linear(duration: 0.3))
                
            }
        }
    }
}

struct Listview_Previews: PreviewProvider {
    static var previews: some View {
        Listview(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}


//                        if audioPlayer.isPlaying == false {
//                            Button(action: {
//                                self.audioPlayer.startPlayback(audio: recording.fileURL)
//                            }) {
//                                Image(systemName: "play.circle")
//                                    .imageScale(.large)
//                            }
//                        } else {
//                            Button(action: {
//                                self.audioPlayer.stopPlayback()
//                            }) {
//                                Image(systemName: "stop.fill")
//                                    .imageScale(.large)
//                            }
//                        }


//                VStack {
//                    HStack {
//                        Text("\(recording.fileURL.lastPathComponent)")
//                        Spacer()
//                    }
//                    HStack {
//                        Spacer()
//                        if audioPlayer.isPlaying == false {
//                            Button(action: {
//                                self.audioPlayer.startPlayback(audio: recording.fileURL)
//                            }) {
//                                Image(systemName: "play.circle")
//                                    .resizable()
//                                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 40, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                    .imageScale(.large)
//                            }
//                        } else {
//                            Button(action: {
//                                self.audioPlayer.stopPlayback()
//                            }) {
//                                Image(systemName: "stop.fill")
//                                    .resizable()
//                                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 40, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                    .imageScale(.large)
//                            }
//                        }
//                        Spacer()
//                    }
//                }
