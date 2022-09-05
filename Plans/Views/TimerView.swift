//
//  TimerView.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 01/02/22.
//

import SwiftUI
import AudioToolbox
import SwiftUI

struct TimerView: View {
    
    @Environment(\.scenePhase) var scene
    let exerciseName: String
    var time:Double
    @Binding var start:Bool
    @Binding var to:CGFloat
    @Binding var count:Double
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var exitTime:Date
    @Binding var diff: Double
    
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.blue.opacity(0.5),style: StrokeStyle.init(lineWidth: 20, lineCap: .round))
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color.blue,style: StrokeStyle.init(lineWidth: 20, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(Angle(degrees: -90))
                    
                    Text("\(self.count,specifier: "%.0f")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .onAppear {
                    self.count = self.time
                }
                
                HStack(spacing:20) {
                    Button {
                        withAnimation {
                            self.start.toggle()
                        }
                        
                        if (self.start) {
                            if (self.count == self.time) {
                                NotificationManager.instance.scheduleNotification(time: self.time, exersiceName:exerciseName)
                                NotificationManager.instance.cancelDeliveredNotification()
                            }
                        } else {
                            NotificationManager.instance.cancelScheduledNotifications()
                            withAnimation {
                                self.count = self.time
                                self.to = 1
                            }
                        }
                    } label: {
                        HStack(spacing:15) {
                            Image(systemName: self.start ? "xmark.circle" : "play.circle")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2))
                        .background(.blue)
                        .clipShape(Capsule())
                    }
                    .padding(.top,40)
                }
            }
        }
        .onReceive(self.timer) { _ in
            if (self.start == true) {
                
                if (self.count > 0) {
                    withAnimation {
                        self.start = false
                        self.count -= 1
                        self.to = CGFloat(self.count/self.time)
                        self.start = true
                    }
                    
                    
                } else if (self.count == 0 ) {

                    withAnimation {
                        self.count = self.time
                        self.start = false
                        AudioServicesPlayAlertSound(1151)
                        self.count = self.time
                        self.to = 1
                    }
                    
                }
                
            }
        }
        .onDisappear {
            self.start = false
            self.to = 1
            self.count = 0.0
            self.diff = 0
        }
    }
}
