//
//  TranscriptTextView.swift
//  Mic
//
//  Created by Nani on 27/07/22.
//

import SwiftUI

struct TranscriptTextView: View {
    
    @State var transcript: Transcript?
    var body: some View {
        if(transcript != nil){
            let t = try? String(contentsOf: transcript!.fileURL)
            if(t != nil){
                Text(t!)
            }
        }
    }
}

struct TranscriptTextView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptTextView()
    }
}
