//
//  TranscriptsListView.swift
//  Mic
//
//  Created by Lalith  on 25/07/21.
//

import SwiftUI

struct TranscriptsListView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @State var isTranscriptOpened: Bool = false
    @State var selectedTranscript: Transcript?
    
    var body: some View {
        
        List {
            ForEach(audioRecorder.transcripts, id: \.createdAt) { transcript in
                HStack{
                    
                    Text("\(transcript.fileURL.lastPathComponent)")
                    
                }.onTapGesture {
                    selectedTranscript = transcript
                    isTranscriptOpened = true
                    print(selectedTranscript)
                }
            }
        }
        .sheet(isPresented: $isTranscriptOpened) {
            
            NavigationView {
//                if(selectedTranscript != nil){
                    TranscriptTextView(transcript: selectedTranscript)
                        .navigationTitle(selectedTranscript!.fileURL.lastPathComponent)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    isTranscriptOpened = false
                                }
                            }
                        }
//                }
            }
        }
        .onAppear {
            selectedTranscript =  audioRecorder.transcripts[0]
        }
//        .she
        
    }
}

struct TranscriptsListView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptsListView(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}
