//
//  ContentView.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder(numberOfSamples: 30)
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var selectedIndex = 1
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                HStack{
                    Button(action: {
                        selectedIndex = 1
                    }, label: {
                        VStack(spacing: 8) {
                            Text("Recordings")
                                .foregroundColor(self.selectedIndex == 1 ? .primary : Color.primary.opacity(0.7))
                            Capsule()
                                .fill(self.selectedIndex == 1 ? Color.primary : Color.clear)
                                .frame(height: 4)
                            
                        }
                    })
                    Button(action: {
                        selectedIndex = 2
                    }, label: {
                        VStack(spacing: 8) {
                            Text("Transcripts")
                                .foregroundColor(self.selectedIndex == 2 ? .primary : Color.primary.opacity(0.7))
                            Capsule()
                                .fill(self.selectedIndex == 2 ? .primary : Color.clear)
                                .frame(height: 4)
                            
                        }
                    })
                }.padding(.top,20)
                if(selectedIndex==1){
                    Listview(audioRecorder: audioRecorder)
                }
                else{
                    TranscriptsListView()
                }
                BottomSheetView(audioRecorder: audioRecorder)
            }
            .navigationBarTitle("Mic Recordings",displayMode: .inline)
            .navigationTitle("Your Recordings")
            .listStyle(PlainListStyle())
            .navigationBarItems(
                trailing:
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                    })
            )
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
