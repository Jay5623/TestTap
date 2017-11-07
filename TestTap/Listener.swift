//
//  Listener.swift
//  MicrophoneAnalysis
//
//  Created by jay macdonald on 2017-10-30.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

// compile with one of the following buffer sizes uncommented
let bSize: UInt32 = 512  // about 5K samnples/sec
//let bSize: UInt32 = 1024  // about 10K samples/sec
//let bSize: UInt32 = 2048  // about 20K samples/sec
//let bSize: UInt32 = 4096  // about 40K samples/sec
//let bSize: UInt32 = 8192  // about 44K samples /sec


var audioRate = 44100.0
var numSamples = 0
var numBuffers = 0
var missingSamples = 0.0
var expectedAudioTime = 1.0 / (audioRate / Double(bSize))
var lastAudioTime = 0.0

open class MyTap {
    internal let bufferSize = bSize
    


    public init(_ input: AKNode?) {
        input?.avAudioNode.installTap(onBus: 0, bufferSize: bufferSize, format: nil /* AudioKit.format */) { buffer, _ in

            numSamples += Int(self.bufferSize)
            numBuffers += 1
            let nextAudioTime = CFAbsoluteTimeGetCurrent()
            missingSamples += (nextAudioTime - lastAudioTime - expectedAudioTime) * audioRate
            lastAudioTime = nextAudioTime

        }
    }
}

class Listener {

    var loaded = false
    var displayed = false
    
    var mic: AKMicrophone!
    var booster: AKBooster!
    var myTap: MyTap!
 
    init() {
        
    }
    
    func afterLoad() {
        assert(!loaded)
        AKSettings.audioInputEnabled = true

        mic = AKMicrophone()
        myTap = MyTap(mic)  // seriously, can it be that easy?
        booster = AKBooster(mic,gain:0.0)
        
        loaded = true
    }
    
   func afterDisplay() {
        assert(loaded)
        assert(!displayed)

        displayed = true
    
        lastAudioTime = CFAbsoluteTimeGetCurrent()
        // start 'er up
        AudioKit.output = booster
        AudioKit.start()
        
   }
}

