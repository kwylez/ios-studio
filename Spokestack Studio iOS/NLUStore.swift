//
//  NLUStore.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/14/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

class NLUStore:  ObservableObject {

    @Published var result: NLUResult?
    
    @Published var benchmark: Double = 0
    
    @Published var error: Error?
    
    private var configuration: SpeechConfiguration = SpeechConfiguration()
    
    private var nlu: NLUTensorflow? = nil
    
    private var startTime = CFAbsoluteTimeGetCurrent()
    
    init(_ result: NLUResult?) {
        self.result = result
    }
    
    func configureNLU(_ modelName: String, metadataName: String) {
        
        let c: SpeechConfiguration = SpeechConfiguration()
        
        guard let modelPath = Bundle(for: type(of: self)).path(forResource: modelName, ofType: "tflite") else {
            print("could not find \(modelName).tflite in bundle")
            return
        }
        c.nluModelPath = modelPath

        guard let vocabPath = Bundle(for: type(of: self)).path(forResource: "vocab", ofType: "txt") else {
            print("could not find vocab.txt in bundle")
            return
        }
        c.nluVocabularyPath = vocabPath
        
        guard let metadataPath = Bundle(for: type(of: self)).path(forResource: metadataName, ofType: "json") else {
            print("could not find \(metadataName).json in bundle")
            return
        }
        c.nluModelMetadataPath = metadataPath
        
        self.configuration = c
        self.nlu = nil
    }
    
    func classify (_ text: String) {
        
        self.startTime = CFAbsoluteTimeGetCurrent()
        self.error = nil
        
        print("classifying \(text)")
        
        if self.nlu == nil {
            self.nlu = try! NLUTensorflow(self, configuration: self.configuration)
        }
        
        self.nlu?.classify(utterance: text)
    }
}

extension NLUStore: NLUDelegate {
    
    func classification(result: NLUResult) {
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Classification: \(result) in \(timeElapsed)")
        DispatchQueue.main.async {
            
            self.benchmark = timeElapsed * 1000
            self.result = result
            self.error = nil
        }
    }
    
    func didTrace(_ trace: String) {
        print("Trace: \(trace)")
    }
    
    func failure(error: Error) {
        print("Failure: \(error)")
        
        DispatchQueue.main.async {
            
            self.error = error
            self.result = nil
        }   
    }
}
