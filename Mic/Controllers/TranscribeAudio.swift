//
//  TranscribeAudio.swift
//  Mic
//
//  Created by Lalith  on 01/08/21.
//

import Foundation
import Speech

class TranscribeAudio: NSObject,ObservableObject {
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    
    func transcribeAudio(url: URL) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        // start recognition!
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let DirPath = documentURL.appendingPathComponent("Transcripts")
                try? FileManager.default.createDirectory(atPath: DirPath.path, withIntermediateDirectories: true, attributes: nil)
//                let file = AVAudioFile(forWriting: documentURL.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).txt"), settings: )
                let file = DirPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).txt")
                try? result.bestTranscription.formattedString.write(to: file,atomically: true,encoding: .utf8)
                print(result.bestTranscription.formattedString)
            }
        }
    }
    
}
