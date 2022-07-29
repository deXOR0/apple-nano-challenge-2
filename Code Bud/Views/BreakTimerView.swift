//
//  BreakTimerView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 27/07/22.
//

import SwiftUI

struct BreakTimerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var breakDurationSec: Int
    
    @State var timerRunning: Bool = true
    @State var timerDataInitialized: Bool = false
    @State var timeLeft: String = "00:00:00"
    @State var progress: Float = 1.0
    @State var breakTimeLeft: String = ""
    @State var startTime: Date = Date.now
    @State var endTime: Date = Date.now
    @State var elapsedTime: Int = 0
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack {
                    Spacer()
                    CircularProgressBarComponent(progress: $progress, timeLeft: $timeLeft, breakTimeLeft: $breakTimeLeft, mode: .onBreak)
                        .frame(width: 346, height: 346)
                    Spacer()
                    HStack {
                        Button {
                            self.timerRunning = false
                            NotificationHandler.deleteNotifications()
                            dismiss()
                        } label: {
                            Text("End Break Now")
                        }
                        .frame(maxWidth: 361, minHeight: 50)
                        .background(Color.primaryColor)
                        .tint(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("On Break")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.primaryColor)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if timerRunning {
                updateTimer()
            }
        }
    }
    
    func updateTimer() {
        
        if !timerDataInitialized {
            timerDataInitialized = true
            initializeTimerData()
        }
        
        let now = Date.now
        let diff = endTime.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if diff <= 0 {
            timerRunning = false
            dismiss()
        }
        else if timerRunning {
            
            self.elapsedTime = self.breakDurationSec - Int(diff)
            
            var secondsLeft = Int(diff)
            let hours = secondsLeft / 3600
            secondsLeft %= 3600
            let minutes = secondsLeft / 60
            secondsLeft %= 60
            let seconds = secondsLeft
            
            self.timeLeft = formatTime([hours, minutes, seconds].map { String($0) })
            self.progress = 1.0 - Float(diff) / Float(self.breakDurationSec)
        }
    }
        
    func rebaseTimer() {
        self.startTime = Date.now
        self.endTime = Calendar.current.date(byAdding: .second, value: self.breakDurationSec - self.elapsedTime, to: self.startTime)!
        NotificationHandler.addNotification(title: "Break Time's Over", subtitle: "Hey user, let's get back to work!", date: self.endTime)
        self.timerRunning = true
    }
    
    func initializeTimerData() {
        print("Initializing")
        rebaseTimer()
    }
    
    func formatTime(_ time: [String]) -> String {
        let hour = String(format: "%02d", Int(time[0])!)
        let minute = String(format: "%02d", Int(time[1])!)
        let second = String(format: "%02d", Int(time[2])!)
        
        return "\(hour):\(minute):\(second)"
    }
    
}

//struct BreakTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        @StateObject var notificationHandler = NotificationHandler()
//        
//        BreakTimerView(notificationHandler: notificationHandler, breakDurationSec: 20)
//    }
//}
