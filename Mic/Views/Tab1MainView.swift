//
//  Tab1MainView.swift
//  Mic
//
//  Created by Lalith  on 25/07/21.
//

import SwiftUI

struct Tab1MainView: View {
    
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

struct Tab1MainView_Previews: PreviewProvider {
    static var previews: some View {
        Tab1MainView()
    }
}
