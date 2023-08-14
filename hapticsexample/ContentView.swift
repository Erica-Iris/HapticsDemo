//
//  ContentView.swift
//  hapticsexample
//
//  Created by Iris on 2023-08-09.
//

import SwiftUI
import UIKit
import CoreHaptics
struct ContentView: View {
    @State private var engine:CHHapticEngine?
    
    @State var intensity=0.5
    @State var sharpness=0.5


    func feedbackgenerate(type:UINotificationFeedbackGenerator.FeedbackType){
        let generate=UINotificationFeedbackGenerator()
        generate.notificationOccurred(type)
    }
    
    
    func Button_gen(text:String,type:UINotificationFeedbackGenerator.FeedbackType)->some View{
        Button(text){
            feedbackgenerate(type: type)
        }
        .frame(width:120,height: 40)
        .background(.purple)
        .font(.headline)
        .clipShape(RoundedRectangle(cornerRadius:10))
    }
    
    
    func prepareEngine(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
        
        do{
            engine = try CHHapticEngine()
            try engine?.start()
        }catch {
            print("this is some thing wrong with create tapic engine\(error.localizedDescription)")
        }
    }
    
    func complexSuccess(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
        var events=[CHHapticEvent]()
        
            let intensity=CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensity))
            let Sharpness=CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpness))
            let event=CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,Sharpness], relativeTime: 0)
            events.append(event)
        do{
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player=try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
        }catch{
            print("Failed to play pattern\(error.localizedDescription)")
        }
    }

    var body: some View {
        HStack{
            Button_gen(text: "Success", type: .success)
            
            Button_gen(text: "Error", type: .error)
            
            Button_gen(text: "Warning", type: .warning)}
        VStack{
            Button("a")
            {complexSuccess()}
                .frame(width:120 ,height: 40)
                .background(.purple)
                .font(.title)
                .clipShape(RoundedRectangle(cornerRadius:10))
                .onAppear(perform: prepareEngine)
                .onTapGesture(perform: complexSuccess)
            Spacer()
            Text("Intensity: \(intensity)")
            Slider(value: $intensity,in:0...1.0)
                .tint(.blue)
            Text("Sharpness: \(sharpness)")
            Slider(value: $sharpness, in:0...1.0)
                .tint(.green)
        }.padding()
    }
}

#Preview {
    ContentView()
}
