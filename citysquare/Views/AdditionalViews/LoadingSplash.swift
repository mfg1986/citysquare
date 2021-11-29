//
//  LoadingSplash.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 29/11/21.
//

import SwiftUI

struct LoadingSplash: View {
    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            Text("loading").foregroundColor(.white)
        }
        .padding()
        .background(Color("ultra_dark_gray"))
        //.cornerRadius(40)
        .clipShape(Circle())
        

  
    }
}

fileprivate struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicatorLoading = UIActivityIndicatorView(style: style)
        indicatorLoading.color = .white
        return indicatorLoading
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingSplash_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray
        .overlay(LoadingView())
        
    }
}


