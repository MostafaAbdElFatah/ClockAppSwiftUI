//
//  ClockView.swift
//  PrayerWidgetExtension
//
//  Created by Mostafa Abd ElFatah on 8/20/20.
//  Copyright © 2020 Arabia IT. All rights reserved.
//
import SwiftUI


struct HandClock: Shape {
    var height:CGFloat = 30
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: height))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 10))
        }
    }
}


struct ClockView: View {

    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var hours:Double = hour(from: Date())
    @State var mintues:Double = minute(from: Date())
    @State var seconds:Double = second(from: Date())
    
    func digit(at digit: Int, rect:CGRect) -> some View {
        Text("\(digit)")
            .foregroundColor(.white)
            .font(.system(size: 13.0))
            .position( self.position(for: digit, in: rect))
        //.opacity(tick % 5 == 0 ? 1 : 0.4)
    }
    
    private func position(for index: Int, in rect: CGRect) -> CGPoint {
        let rect = rect.insetBy(dx: 0, dy: 0)
        let angle = ((2 * .pi) / CGFloat(12) * CGFloat(index)) - .pi/2
        let radius = min(rect.width, rect.height)/2 - 18
        return CGPoint(x: rect.midX + radius * cos(angle),
                       y: rect.midY + radius * sin(angle))
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            ForEach(0..<60) { second in
                Path { path in
                    path.move(to: .init(x: geometryReader.size.width/2, y: 0))
                    path.addLine(to: .init(x: geometryReader.size.width/2, y: 8))
                }
                .stroke(lineWidth: second % 5 == 0 ? 6 : 3)
                .rotation(.init(degrees: Double(second) * 360/60))
                .foregroundColor(.white)
            }
            
            GeometryReader{ geometry in
                ForEach(1..<13) { digit in
                    self.digit(at: digit, rect: geometry.frame(in: CoordinateSpace.local))
                }
            }
            
            // Hours hand.
            HandClock(height: 50)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: hours * 360/12))
            
            // Minutes hand.
            HandClock(height: 30)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: mintues * 360/60))
           
            // Second hand.
            HandClock(height: 15)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: seconds * 360/60))
            
            GeometryReader{ geometry in
                
                Circle()
                    .position(x: geometry.frame(in: CoordinateSpace.local).width / 2, y: geometry.frame(in: CoordinateSpace.local).height / 2)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.white)
            }
            
        }.onReceive(self.timer, perform: { _ in
            print("timer")
            self.hours = hour(from: Date())
            self.mintues = minute(from: Date())
            self.seconds = second(from: Date())
        })
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


private func hour(from date: Date) -> Double {
    let hour = Double(Calendar.current.dateComponents([.hour], from: date).hour!)
    let minute = Double(Calendar.current.dateComponents([.minute], from: date).minute!)
    let seconds = Double(Calendar.current.dateComponents([.second], from: date).second!)
    
    return (seconds + minute * 60 + hour * 60 * 60) / (60 * 60)
}

private func minute(from date: Date) -> Double {
    let minute = Double(Calendar.current.dateComponents([.minute], from: date).minute!)
    let seconds = Double(Calendar.current.dateComponents([.second], from: date).second!)
    
    return (seconds + minute * 60) / 60
}

private func second(from date: Date) -> Double {
    let seconds = Double(Calendar.current.dateComponents([.second], from: date).second!)
    
    return seconds
}
