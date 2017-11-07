//
//  ViewController.swift
//  TestTap
//
//  Created by jay macdonald on 2017-11-04.
//  Copyright © 2017 jaymacdonald. All rights reserved.
//
//  This code installs an Audio Kit tap on the microphone that simply adds up the number of samples captured.
//  The capture rate should be 44.1 Khz, but veries depending on the buffer size allocated

import UIKit


class ViewController: UIViewController {
    var timer : Timer!
    let listener = Listener()  // contains the tap
    
//    var startTimer = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // force the View to refresh at 60 hz
        timer = Timer.scheduledTimer(timeInterval: 1/60.0,
                                     target: self,
                                     selector: #selector(self.timerTick),
                                     userInfo: nil,
                                     repeats: true)
        
        listener.afterLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener.afterDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var startTime = 0.0
    
    // time tick prints
    // - number of times the audio tap has been passed data
    // - number of samples per second average since start-up
    // - samples per second if 'missing samples' were manufactured by tap : ) <- how I'm going to hack around this problem 
    @objc func timerTick() {
        if startTime == 0.0 {
            startTime = CFAbsoluteTimeGetCurrent()
        } else {
            print ( numBuffers,
                    Double(numSamples ) / ( CFAbsoluteTimeGetCurrent() - startTime),
                    Double(numSamples + Int(missingSamples)) / ( CFAbsoluteTimeGetCurrent() - startTime))
        }

  }
}

