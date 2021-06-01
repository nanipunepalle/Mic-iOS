//
//  AirplayView.swift
//  Mic
//
//  Created by Lalith  on 29/05/21.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit

struct AirPlayView: UIViewRepresentable{
    @ObservedObject var audioRecorder: AudioRecorder
    

    func makeUIView(context: Context) -> UIView {

        let routePickerView = AVRoutePickerView()
        routePickerView.backgroundColor = UIColor.clear
        routePickerView.tintColor = UIColor(.primary)
        let button = routePickerView.subviews.first(where: { $0 is UIButton }) as? UIButton
        button?.setTitleColor(.red, for: .normal)
        button?.setBackgroundImage(UIImage(systemName: "airplayaudio"), for: .normal)
        return routePickerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // do nothing
    }
}
