//
//  ListRowView.swift
//  Mic
//
//  Created by Lalith  on 01/08/21.
//

import SwiftUI

struct ListRowView: View {
    
    @State var isExpanded: Bool = false
    @State var showAlert: Bool = false
    @State var recording: Recording?
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(recording!.fileURL.lastPathComponent)")
                Spacer()
                Image(systemName: isExpanded ? "chevron.down": "chevron.forward").padding()
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                isExpanded = !isExpanded
            })
            if isExpanded{
                HStack {
                    Button(action: {
                        print("More button clicked")
                        actionSheet()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .padding()
                            .imageScale(.large)
                    }).buttonStyle(PlainButtonStyle())
                    Spacer()
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: recording!.fileURL)
                        }) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(minWidth: 30, idealWidth: 30, maxWidth: 30, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }.buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .frame(minWidth: 30, idealWidth: 30, maxWidth: 30, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .padding()
                    })
                    .buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Are you sure"),
                              message: Text("You cannot revert it"),
                              primaryButton: .destructive(Text("Delete")) {
                                audioRecorder.deleteRecording(urlsToDelete: [recording!.fileURL])
                              },
                              secondaryButton: .cancel())
                    })
                }
            }
        }
    }
    
    func actionSheet() {
        guard let fileShare = recording?.fileURL else { return }
           let activityVC = UIActivityViewController(activityItems: [fileShare], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
       }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(isExpanded: true,recording: AudioRecorder(numberOfSamples: 30).recordings[0],audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}
