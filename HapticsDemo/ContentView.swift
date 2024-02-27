//
//  ContentView.swift
//  hapticsexample
//
//  Created by Iris on 2023-08-09.
//

import CoreHaptics
import SwiftUI
import UIKit
struct ContentView: View {
    @State private var engine: CHHapticEngine?
    @State private var isDragging=false
    
    @State public var intensity=0.5
    @State public var sharpness=0.5
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging=true }
            .onEnded { _ in self.isDragging=false }
    }

    func feedbackgenerate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generate=UINotificationFeedbackGenerator()
        generate.notificationOccurred(type)
    }
    
    func Button_gen(text: String, type: UINotificationFeedbackGenerator.FeedbackType)->some View {
        Button(text) {
            feedbackgenerate(type: type)
        }
        .frame(width: 120, height: 40)
        .background(.purple)
        .font(.headline)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func TapArea()->some View {
        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
            .fill(.red)
            .frame(width: 350, height: 350)
            .onTapGesture { location in
                print("Tapped at \(location)")
                intensity=location.x/350
                sharpness=location.y/350
            }
            .gesture(
                DragGesture()
                    .onChanged { Value in
                        print(Value.translation.width, Value.translation.height)
                        intensity=(Value.startLocation.x + Value.translation.width)/350.0
                        sharpness=(Value.startLocation.y + Value.translation.height)/350.0
                        if intensity > 1 {
                            intensity=1.0
                        }
                        if sharpness > 1 {
                            sharpness=1.0
                        }
                        if intensity<0 {
                            intensity=0
                        }
                        if sharpness<0 {
                            sharpness=0
                        }
                        print(intensity, sharpness)
                        complexSuccess()
                    }
            )
            
    }
    
    func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine=try CHHapticEngine()
            try engine?.start()
        } catch {
            print("this is some thing wrong with create tapic engine\(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events=[CHHapticEvent]()
        
        print(intensity, sharpness)
        
        let intensity=CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensity))
        let Sharpness=CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpness))
        let event=CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, Sharpness], relativeTime: 0)
        events.append(event)
        do {
            let pattern=try CHHapticPattern(events: events, parameters: [])
            let player=try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
        } catch {
            print("Failed to play pattern\(error.localizedDescription)")
        }
    }

    var body: some View {
        Text("Tapic Engine Test")
            .font(.title)
        HStack {
            Button_gen(text: "Success", type: .success)
            
            Button_gen(text: "Error", type: .error)
            
            Button_gen(text: "Warning", type: .warning)
        }

        VStack {
            Button("a")
                { complexSuccess() }
                .frame(width: 120, height: 40)
                .background(.purple)
                .font(.title)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onAppear(perform: prepareEngine)
                .onTapGesture(perform: complexSuccess)

            TapArea()
            Text("Intensity: \(intensity)")
            Slider(value: $intensity, in: 0...1.0)
                .tint(.blue)
            Text("Sharpness: \(sharpness)")
            Slider(value: $sharpness, in: 0...1.0)
                .tint(.green)
        }.padding()
    }
}

#Preview {
    ContentView()
        
}
