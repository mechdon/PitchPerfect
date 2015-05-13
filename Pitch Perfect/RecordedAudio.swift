//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Gerard Heng on 28/2/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePath url:NSURL, title titled:String){
        filePathUrl = url
        title = titled
    }
    
    
}