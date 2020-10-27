//
//  ContentView.swift
//  OnboardScreen
//
//  Created by RJ Hrabowskie on 10/23/20.
//

import SwiftUI

struct ContentView: View {
    @State var goToHome = false
    
    var body: some View {
        ZStack {
            if goToHome {
                Text("Home Screen")
            } else {
                OnboardingScreen()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Success")), perform: { _ in
            withAnimation {self.goToHome = true}
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct OnboardingScreen: View {
    
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer(minLength: 0)
                
                Text("LEARN SMART")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Don't waste your time. Learn something new with our app and make your skills better!")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer(minLength: 0)
                
                ZStack {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    
                    // Background Progress
                    Text("SWIPE TO START")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                    
                    HStack {
                        Capsule()
                            .fill(Color("red"))
                            .frame(width: calculateWidth() + 65)
                        
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        ZStack {
                            Image(systemName: "chevron.right")
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                        }
                        .foregroundColor(.white)
                        .offset(x: 5)
                        .frame(width: 65, height: 65)
                        .background(Color("red"))
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChanged(value:))
                                    .onEnded(onEnd(value:)))
                        
                        Spacer()
                    }
                }
                .frame(width: maxWidth, height: 65)
                .padding(.bottom)
            }
        }
    }
    
    func calculateWidth() -> CGFloat {
        let percent = offset / maxWidth
        
        return percent * maxWidth
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width > 0 && offset <= maxWidth - 65 {
            offset = value.translation.width
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(Animation.easeOut(duration: 0.3)) {
            if offset > 180 {
                offset = maxWidth - 65
                
                // Notify User
                // Delay for the animation to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
                }
            } else {
                offset = 0
            }
        }
    }
}
