//
//  AudioRecorder.swift
//  Mic
//
//  Created by Lalith  on 25/05/21.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import AVKit
import Accelerate


class AudioRecorder: NSObject,ObservableObject {
    
    private var currentSample: Int
    private let numberOfSamples: Int
    private var averagePowerForChannel0: Float = 0
    private var averagePowerForChannel1: Float = 0
    let LEVEL_LOWPASS_TRIG:Float32 = 0.30
    
    @Published public var soundSamples: [Float]
    
    
    init(numberOfSamples: Int) {
        print(numberOfSamples)
        self.soundSamples = [Float](repeating: .zero, count: 30)
        self.currentSample = 0
        self.numberOfSamples = 30
        print(self.numberOfSamples)
        super.init()
        fetchRecordings()
        setupSession()
        setupEngine()
        setupNotifications()
    }
    
    
    //    override init() {
    //        super.init()
    //
    //        fetchRecordings()
    //        setupSession()
    //        setupEngine()
    //        setupNotifications()
    //    }
    
    //    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    @Published public var recordings = [Recording]()
    
    var currentFilePath: AVAudioFile!
    
    @Published public var recording = false
    
    @Published public var inputDeviceName: String! = ""
    @Published public var outputDeviceName: String! = ""
    
    @Published public var inputDevices: [AVAudioSessionPortDescription] = []
    
    enum RecordingState {
        case recording, paused, stopped
    }
    
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var playerNode: AVAudioPlayerNode!
    private var inputNode: AVAudioInputNode!
    
    private var state: RecordingState = .stopped
    
    
    func setupSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default,options: [.allowBluetoothA2DP])
        try? session.setActive(true)
        inputDeviceName = session.currentRoute.outputs[0].portName
        outputDeviceName = session.currentRoute.inputs[0].portName
        
        inputDevices = session.availableInputs!
    }
    
    func setupNotifications() {
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleRouteChange),
                       name: AVAudioSession.routeChangeNotification,
                       object: nil)
    }
    
    
    @objc func handleRouteChange(notification: Notification) {
        let session = AVAudioSession.sharedInstance()
        if(state == .recording){
            stopRecording2()
        }
        setupEngine()
//        print(session.currentRoute)
        inputDeviceName = session.currentRoute.inputs[0].portName
        outputDeviceName = session.currentRoute.outputs[0].portName
        if(state == .recording){
            startRecording2()
        }
    }
    
    func updatePreferedInput(preferedInput: AVAudioSessionPortDescription) -> Void {
        let session = AVAudioSession.sharedInstance()
        try? session.setPreferredInput(preferedInput)
    }
    
    func setupEngine() {
        engine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        playerNode = AVAudioPlayerNode()
        playerNode.destination(forMixer: mixerNode, bus: 0)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.cathedral)
        reverbNode.wetDryMix = 10
        
        // Set volume to 0 to avoid audio feedback while recording.
        mixerNode.volume = 0
        
        engine.attach(mixerNode)
        engine.attach(playerNode)
        engine.attach(reverbNode)
        
        makeConnections()
        
        // Prepare the engine in advance, in order for the system to allocate the necessary resources.
        engine.prepare()
    }
    
    func makeConnections() {
        inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        engine.connect(inputNode, to: mixerNode, format: inputFormat)
        
        let mainMixerNode = engine.mainMixerNode
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: true)
        engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
        engine.connect(playerNode, to: mainMixerNode, format: mixerFormat)
    }
    
    func startRecording2() {
        
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do{
            let file = try AVAudioFile(forWriting: documentURL.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).caf"), settings: format.settings)
            currentFilePath = file
        }
        catch {
            print("Fnot working")
        }
        
        tapNode.installTap(onBus: 0, bufferSize: 2048, format: format, block: {
            (buffer, time) in
            
            //            self.audioMetering(buffer: buffer)
            DispatchQueue.main.async {
                self.soundSamples[self.currentSample] = Float(Int.random(in: 10...30))
                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            }
            
            self.playerNode.scheduleBuffer(buffer, at: nil, completionHandler: nil)
            
            do{
                try self.currentFilePath.write(from: buffer)
            }
            catch {
                print("Fnot working")
            }
            
        })
        do {
            try engine.start()
            self.playerNode.play()
            recording = true
        } catch {
            print("Fnot working")
        }
        state = .recording
    }
    
    func resumeRecording() throws {
        try engine.start()
        state = .recording
    }
    
    func pauseRecording() {
        engine.pause()
        state = .paused
    }
    
    func stopRecording2() {
        // Remove existing taps on nodes
        mixerNode.removeTap(onBus: 0)
        inputNode.removeTap(onBus: 0)
        engine.stop()
        recording = false
        playerNode.stop()
        state = .stopped
        fetchRecordings()
    }
    
    
    //audiometering using high cpu so not usaing for now
    private func audioMetering(buffer:AVAudioPCMBuffer)  {
        print("e")
        buffer.frameLength = 1024
        let inNumberFrames:UInt = UInt(buffer.frameLength)
        if buffer.format.channelCount > 0 {
            print("bb")
            let samples = (buffer.floatChannelData![0])
            var avgValue:Float32 = 0
            vDSP_meamgv(samples,1 , &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0)
            self.averagePowerForChannel1 = self.averagePowerForChannel0
            DispatchQueue.main.async {
                self.soundSamples[self.currentSample] = self.averagePowerForChannel0
                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            }
        }
        
        if buffer.format.channelCount > 1 {
            print("dd")
            let samples = buffer.floatChannelData![1]
            var avgValue:Float32 = 0
            vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel1)
        }
    }
    
    
    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        //        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecordings()
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
