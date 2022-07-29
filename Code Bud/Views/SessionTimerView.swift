//
//  SessionTimerView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import SwiftUI

struct SessionTimerView: View {
    
    var sessionDuration: [String]
    var breakInterval: String
    var breakDuration: String

    @State var sessionDurationSec: Int = 0
    @State var breakIntervalSec: Int = 0
    @State var breakDurationSec: Int = 0
    
    @Environment(\.dismiss) var dismiss
    @State var breakTimerSheet = false
    @State var pauseBreakTimerSheet = false
    @State var summarySheet = false
    
    @State var progress: Float = 1.0
    @State var elapsedTime: Int = 0
    @State var timeLeft: String = "00:00:00"
    @State var breakTimeLeft: String = "0 seconds"
    @State var nextBreakTime: Date = Date.now
    @State var timerDataInitialized: Bool = false
    @State var timerRunning: Bool = true
    @State var startTime: Date = Date.now
    @State var originalStartTime: Date = Date.now
    @State var endTime: Date = Date.now
    @State var timerEnding: Bool = false
    @State var breakCount: Int = 0
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack {
                    Spacer()
                    CircularProgressBarComponent(progress: $progress, timeLeft: $timeLeft, breakTimeLeft: $breakTimeLeft, mode: timerEnding ? .onBreak : .coding)
                        .frame(width: 346, height: 346)
                    Spacer()
                    HStack {
                        Button {
                            self.timerRunning = false
                            self.breakTimerSheet = true
                            self.breakCount += 1
                        } label: {
                            Text("Take a Break Now")
                        }
                        .frame(maxWidth: 172, minHeight: 50)
                        .background(Color.primaryColor)
                        .tint(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                        Button {
                            self.timerRunning = false
                            self.endTime = Date.now
                            self.summarySheet = true
                        } label: {
                            Text("End Session")
                        }
                        .frame(maxWidth: 172, minHeight: 50)
                        .background()
                        .tint(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Coding Session")
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
        .sheet(isPresented: $breakTimerSheet, onDismiss: restartTimer) {
            BreakTimerView(breakDurationSec: self.breakDurationSec)
        }
        .sheet(isPresented: $pauseBreakTimerSheet, onDismiss: unpauseTimer) {
            BreakTimerView(breakDurationSec: self.breakDurationSec)
        }
        .sheet(isPresented: $summarySheet, onDismiss: restartTimer) {
            SessionSummaryView(startDate: self.originalStartTime, endDate: self.endTime, codingDuration: self.elapsedTime, breakCount: self.breakCount, breakDuration: self.breakDuration, journal: "")
        }
    }
    
    func unpauseTimer() {
        self.elapsedTime += self.breakDurationSec
        rebaseTimer()
    }
    
    func restartTimer() {
        rebaseTimer()
    }
    
    func updateTimer() {
        
        if (!timerDataInitialized) {
            timerDataInitialized = true
            initializeTimerData()
        }
        
        let now = Date.now
        let diff = endTime.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if diff <= 0 {
            self.summarySheet = true
        }
        else if timerRunning {
            
            self.elapsedTime = self.sessionDurationSec - Int(diff)
            updateBreakTimeLeft(now: now)
            
            var secondsLeft = Int(diff)
            let hours = secondsLeft / 3600
            secondsLeft %= 3600
            let minutes = secondsLeft / 60
            secondsLeft %= 60
            let seconds = secondsLeft
            
            self.timeLeft = formatTime([hours, minutes, seconds].map { String($0) })
            self.progress = 1.0 - Float(diff) / Float(self.sessionDurationSec)
        }
    }
    
    func updateBreakTimeLeft(now: Date) {
        let diff = self.nextBreakTime.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if diff <= 1 {
            if !self.timerEnding {
                self.breakTimerSheet = true
                self.breakCount += 1
            }
            self.timerRunning = false
        }
        else {
            var secondsLeft = Int(diff)
            secondsLeft %= 3600
            let minutes = secondsLeft / 60
            secondsLeft %= 60
            let seconds = secondsLeft
            
            if minutes > 0 {
                self.breakTimeLeft = "\(minutes+1) minutes"
            }
            else {
                self.breakTimeLeft = "\(seconds) seconds"
            }
        }
    }
    
    func rebaseTimer() {
        print("Rebase", self.elapsedTime)
        self.startTime = Date.now
        self.endTime = Calendar.current.date(byAdding: .second, value: self.sessionDurationSec - self.elapsedTime, to: self.startTime)!
        self.nextBreakTime = Calendar.current.date(byAdding: .second, value: self.breakIntervalSec, to: self.startTime)!
        if self.nextBreakTime >= self.endTime {
            self.timerEnding = true
            NotificationHandler.addNotification(title: "Coding Session Complete", subtitle: "You've completed your coding session!", date: self.endTime)
        }
        self.timerRunning = true
    }
    
    func initializeTimerData() {
        let hour = Int(self.sessionDuration[0])! * 3600
        let minutes = Int(self.sessionDuration[1])! * 60
        self.sessionDurationSec = hour + minutes
        
        self.originalStartTime = Date.now
        
        self.breakIntervalSec = Int(self.breakInterval)! * 60
        
        self.breakDurationSec = Int(self.breakDuration)! * 60
        
        rebaseTimer()
    }
    
    func formatTime(_ time: [String]) -> String {
        let hour = String(format: "%02d", Int(time[0])!)
        let minute = String(format: "%02d", Int(time[1])!)
        let second = String(format: "%02d", Int(time[2])!)
        
        return "\(hour):\(minute):\(second)"
    }
    
}

//struct SessionTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionTimerView(sessionDuration: ["0", "2"], breakInterval: "1", breakDuration: "5")
//    }
//}
