//
//  ASRDemoDetail.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/9/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import Spokestack

struct ASRDemoDetail: View {
    
    @ObservedObject var store:PipelineStore
    
    var body: some View {
        ZStack {
            Color("SpokestackBackground")
            VStack {
                Spacer()
                Text(store.text).foregroundColor(Color("SpokestackPrimary")).padding()
                Spacer()
                VStack {
                    Group {
                        if (!store.isListening) {
                            Text("Tap the button below & speak")
                            HintArrowView(arrowheadSize:6).frame(width: 200, height: 150).foregroundColor(Color.primary)
                        }
                    }.transition(
                        AnyTransition.opacity.animation(Animation.linear(duration: 1))
                    )
                    
                    MicButtonView(store:store)
                }.offset(x: 0, y: 60)
                
                recordingView()
                    .transition(
                        AnyTransition.opacity.animation(Animation.linear(duration: 1))
                )
            }
        }
        .navigationBarTitle("Speech Recognition")
        .onAppear {
            self.store.configure(mode: .push2talk)
        }
    }
    
    func recordingView() -> some View {
        Group {
            if (store.isListening) {
                WaveView().frame(height: 100.0)
            } else {
                Spacer().frame(height: 108.0)
            }
        }
    }
    
}

struct ASRDemoDetail_Previews: PreviewProvider {
    static var previews: some View {
        ASRDemoDetail(store:PipelineStore(text:""))
    }
}

