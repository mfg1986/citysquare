//
//  SplashView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 29/11/21.
//

import SwiftUI

struct SplashView: View {
    @State var animationStarted = false
    
    @State private var textValue: String = "Welcome!"
    @State private var opacity: Double = 1
    
    @State var showText = false
    
    var foozle: String = "Welcome!"
    @State private var hidden = true
    
    var body: some View {
        VStack{
            //Text("Welcome!").foregroundColor(.white).font(.title)
            Text("Welcome!")
                .foregroundColor(.white)
                .font(.title)
                .padding()/*
                .opacity(showText ? 0 : 1)
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                  withAnimation() {
                    self.showText = true
                  }
                }*/
          
            LoadingSplash()
            
        }.background(
            Image("bg_detailcity")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
         
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
