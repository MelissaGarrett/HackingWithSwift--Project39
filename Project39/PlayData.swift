//
//  PlayData.swift
//  Project39
//
//  Created by Melissa  Garrett on 3/8/17.
//  Copyright © 2017 MelissaGarrett. All rights reserved.
//

import Foundation

class PlayData {
    var allWords = [String]()
    var wordCounts: NSCountedSet!
    
    // Setting this property can only be done from within PlayData
    private(set) var filteredWords = [String]()
    
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
                // NSCountedSet: keys can only be added once, and it keeps
                // track of keys' frequencies (still like [String: Int]).
                // Sort() with higher frequencies at top
                wordCounts = NSCountedSet(array: allWords)
                let sorted = wordCounts.allObjects.sorted {
                    wordCounts.count(for: $0) > wordCounts.count(for: $1)
                }
                
                // updates 'allWords', thus no longer having duplicates
                // like it did when loaded from the text file
                allWords = sorted as! [String]
                
                // Initially, a filter for all words containing 'swift'
                applyUserFilter("swift")
            }
        }
    }
    
    // Filter for words whose count is >= user's filter;
    // Filter for words that contain the user's filter (word), ignoring case
    func applyUserFilter(_ input: String) {
        if let userNumber = Int(input) {
            // we got a number
            applyFilter { self.wordCounts.count(for: $0) >= userNumber }
        } else {
            // we got a string
            applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }
    
    // applyFilter is a function that accepts a function (filter) that 
    // accepts a String and returns a Bool
    func applyFilter(_ filter: (String) -> Bool) {
        filteredWords = allWords.filter(filter)
    }
}
