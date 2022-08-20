 //
//  BottomSheetView.swift
//  Mic
//
//  Created by Lalith  on 29/05/21.
//

import SwiftUI

let numberOfSamples: Int = 30

struct BottomSheetView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State private var showingSheet = false
    
    @State var height: CGFloat = 150
    
    // for animation based on microphone metering which is not being used due to high cpu usage
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        print(level)
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        print(CGFloat(level * (300 / 100)))
        return CGFloat(level * (300 / 100)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                if audioRecorder.recording == true{
                    Text("Player")
                    HStack(spacing: 4) {
                        ForEach(audioRecorder.soundSamples, id: \.self) { level in
                            BarView(value: CGFloat(level))
                        }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingSheet = true
                    }, label: {
                        VStack(spacing:10) {
                            Image(systemName: "mic.circle")
                                .resizable()
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 40, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.primary).padding(0)
                            Text(audioRecorder.inputDeviceName)
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                        }
                    })
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 150, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 80, maxHeight: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .actionSheet(isPresented: $showingSheet) {
                        ActionSheet(
                            title: Text("Microphone"),
                            buttons: audioRecorder.inputDevices.enumerated().map({ i,j in
                                Alert.Button.default(Text(j.portName)) {
                                    audioRecorder.updatePreferedInput(preferedInput: j)
                                }
                            }) + [.cancel(Text("Dismiss")),]
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if(audioRecorder.recording){
                            height = 150
                            self.audioRecorder.stopRecording2()
                        }
                        else{
                            self.audioRecorder.startRecording2()
                            height = 300
                        }
                        
                    }) {
                        ZStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.white)
                                .padding(.bottom, 60)
                            
                            if(audioRecorder.recording){
                                Image(systemName: "stop.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipped()
                                    .foregroundColor(.red)
                                    .padding(.bottom, 60)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.black, lineWidth: 1)
                                            .padding(.bottom, 60)
                                    )
                            }
                            else{
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .foregroundColor(.red)
                                    .padding(.bottom, 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 1)
                                            .padding(.bottom, 60)
                                    )
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        AirPlayView(audioRecorder: audioRecorder)
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 40, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        VStack {
                            Text(audioRecorder.outputDeviceName)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(.trailing,5)
                        }
                        
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 40, maxWidth: 150, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 80, maxHeight: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: height, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .frame(height: height, alignment: .bottom)
            .offset(y: 0)
            //            .animation(.default)
        }.frame(height: height, alignment: .bottom)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(audioRecorder: AudioRecorder(numberOfSamples: 10))
    }
}

struct BarView: View {
    var value: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: 5, height: value)
        }
    }
}
