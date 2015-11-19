//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gerard Heng on 28/2/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Declare variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise variables
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.volume = 50.0
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }
    
    //# MARK: - Play Audio Methods
    
    
    // Reset Audio Engine
    func resetAudioEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // Play audio according to rate specified
    func playAudioRate(rate: Float) {
        resetAudioEngine()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Play audio with variable pitch
    func playAudioWithVariablePitch(pitch: Float) {
        resetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
        
    }
    
    // Play audio with slow rate
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioRate(0.5)
    }
    
    // Play audio with fast rate
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioRate(2.0)
    }
    
    // Play audio with Chipmunk effect
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // Play audio with Darthvader effect
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    // Stop playing audio
    @IBAction func stopAudio(sender: UIButton) {
        resetAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   

}
