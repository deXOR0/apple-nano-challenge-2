//
//  SessionStartView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import SwiftUI

struct SessionStartView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingSheet = false
    
    @State var durationData: [(String, [String])] = [
        ("Hour", Array(stride(from: 0, through: 23, by: 1)).map { "\($0)" }),
        ("Minute", Array(stride(from: 0, through: 45, by: 2)).map { "\($0)" })
    ]
    @State var durationSelection: [String] = [4, 30].map { "\($0)" }
    @State var breakIntervalData: [(String, [String])] = [("Minute", Array(stride(from: 1, through: 60, by: 1)).map { "\($0)" })
    ]
    @State var breakIntervalSelection: [String] = ["30"]
    @State var breakDurationData: [(String, [String])] = [("Minute", Array(stride(from: 1, through: 45, by: 1)).map { "\($0)" })
    ]
    @State var breakDurationSelection: [String] = ["15"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack {
                    VStack {
                        HStack {
                            Text("Duration").font(.system(size: 18))
                            Spacer()
                            Text(formatTime(durationSelection))
                                .font(.system(size: 18))
                                .bold()
                        }
                        MultiPickerComponent(data: durationData, selection: $durationSelection).frame(height: 100)
                    }
                    .padding()
                    VStack {
                        HStack {
                            Text("Break Interval").font(.system(size: 18))
                            Spacer()
                            Text(breakIntervalSelection[0])
                                .font(.system(size: 18))
                                .bold()
                            Text("mins")
                        }
                        MultiPickerComponent(data: breakIntervalData, selection: $breakIntervalSelection)
                        .frame(height: 100)
                        
                    }
                    .padding()
                    VStack {
                        HStack {
                            Text("Break Duration").font(.system(size: 18))
                            Spacer()
                            Text(breakDurationSelection[0])
                                .font(.system(size: 18))
                                .bold()
                            Text("mins")
                        }
                        MultiPickerComponent(data: breakDurationData, selection: $breakDurationSelection)
                        .frame(height: 100)
                        
                    }
                    .padding()
                    Spacer()
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Text("Start Session")
                    }
                    .sheet(isPresented: $showingSheet) {
                        SessionTimerView(sessionDuration: durationSelection, breakInterval: breakIntervalSelection[0], breakDuration: breakDurationSelection[0])
                    }
                    .frame(maxWidth: 361, minHeight: 50)
                    .background(Color.primaryColor)
                    .tint(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Session Settings")
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
    }
    
    func formatTime(_ time: [String]) -> String {
        let hour = String(format: "%02d", Int(time[0])!)
        let minute = String(format: "%02d", Int(time[1])!)
        
        return "\(hour):\(minute):00"
    }
    
}

//struct SessionStartView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionStartView()
//    }
//}
