//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gerard Heng on 26/2/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //# MARK: Outlets for label and butons
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopAudio: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // Declare variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Set label text and hide stop button
    override func viewWillAppear(animated: Bool) {
        recordingInProgress.textColor = UIColor.darkGrayColor()
        recordingInProgress.text = "Tap to Record"
        stopAudio.hidden = true
    }
    
    
    //# MARK: - Record Audio Method
    @IBAction func recordAudio(sender: UIButton) {
        
        // Show stop button and change label text
        stopAudio.hidden = false
        recordingInProgress.textColor = UIColor.redColor()
        recordingInProgress.text = "Recording in Progress"
        recordButton.enabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // Create recording name using current date and time
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    // Actions to perform when audio recorder finish recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag) {
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            recordButton.hidden = true
        }
    }
    
    // Prepare for segue to PlaySoundsViewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if(segue.identifier == "stopRecording") {
         let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
        let data = sender as! RecordedAudio
        playSoundsVC.receivedAudio = data
       }
    }
    
    // Stop button pressed
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        recordButton.enabled = true
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

