//
//  ContentView.swift
//  ClockApp
//
//  Created by Mostafa Abd ElFatah on 8/20/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Color.black
                    .edgesIgnoringSafeArea(.all)
                HStack{
                    ClockView()
                } 
                .padding(.all, 50)
                .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
            }.navigationBarTitle(Text("ClockView"), displayMode:.automatic).foregroundColor(.white)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
