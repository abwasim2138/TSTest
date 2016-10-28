//
//  Test.swift
//  TSTest
//
//  Created by Abdul-Wasai Wasim on 10/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import Foundation

struct Test {
    
    var timeStamp: String?
    var questions: [Int]?
    var results: String?

    func calculateResults () -> String? {
        guard self.questions != nil else {return nil}
        return "\(Int(Float(self.questions!.reduce(0, +)) / 4.0 * 100))%"
    }

    func formattedTimeStamp () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: Date())
    }
    
    func makeDictionaryForSaving() -> [String: String] {
       return [
            "timeStamp": formattedTimeStamp(),
            "results": results!
            ]
        
    }
    
    
}
