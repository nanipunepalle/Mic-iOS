//
//  TranscriptsListView.swift
//  Mic
//
//  Created by Lalith  on 25/07/21.
//

import SwiftUI

struct TranscriptsListView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
//        NavigationView {
            List {
                ForEach(audioRecorder.transcripts, id: \.createdAt) { transcript in
                    HStack{
                        Text("\(transcript.fileURL.lastPathComponent)")
                        
                    }
                    
                }
            }
//        }
    }
}

struct TranscriptsListView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptsListView(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}
