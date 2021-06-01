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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Listview(audioRecorder: audioRecorder)
                BottomSheetView(audioRecorder: audioRecorder)
            }
            .navigationBarTitle("Mic Recordings")
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
        ContentView(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}
