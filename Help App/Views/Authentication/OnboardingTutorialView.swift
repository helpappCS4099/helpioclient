//
//  OnboardingTutorialView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 29/03/2023.
//

import SwiftUI

struct OnboardingTutorialView: View {
    
    @State var pageIndex = 0
    
    @State var showCongrats = false
    
    @Binding var showTutorial: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    TabView(selection: $pageIndex) {
                        
                        LearningLandingView()
                            .tag(0)
                            .multilineTextAlignment(.center)
                        
                        LearningFindFriendsPage()
                            .tag(1)
                            .multilineTextAlignment(.center)
                        
                        LearningCallForHelpView()
                            .tag(2)
                            .multilineTextAlignment(.center)
                        
                        RoryView()
                            .tag(3)
                            .multilineTextAlignment(.center)
                        
                        HowToReachView()
                            .tag(4)
                        
                        KeepUpdatedView(onTap: {
                            //show congrats
                            showCongrats = true
                            //close view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showTutorial = false
                            }
                        })
                            .tag(5)
                            .multilineTextAlignment(.center)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: bounds.height * 0.8, alignment: .top)
                    
                    if pageIndex != 5 {
                        Button {
                            //next page
                            withAnimation {
                                pageIndex += 1
                            }
                            
                        } label: {
                            Text(pageIndex != 0 ? "Next" : "Start Tutorial")
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                    } else {
                        Text(showCongrats ? "Fantastic job. Now you are ready." : "Literally. Hit it.")
                    }

                    
                    Spacer()
                }
                
                //button here
            }
        }
    }
}

struct LearningLandingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("appLogoBackground")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: bounds.width)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Welcome to")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("FriendGuard")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 25)
            
            VStack(spacing: 10) {
                Text("Everyone hates tutorials. But if you were to use the app in a critical situation - it’s best to know it.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text("Yep - you can’t skip it.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(.leading, 25)
                
            
            Spacer()
        }
    }
}

struct LearningFindFriendsPage: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Find Friends.")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Even if it's hard.")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 25)
            
            Text("Added friends will be your emergency contacts.")
                .padding([.leading, .trailing])
            
            Spacer()
            
            Image("findFriendsImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: bounds.width * 0.8)
            
            Spacer()
        }
    }
}

struct LearningCallForHelpView: View {
    
    @State var tapped = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("If you need your friends - call them for help*")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 25)
            
            Text("Create a help request.")
                .padding([.leading, .trailing])
            
            Spacer()
            
            VStack {
                Image("createHRImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: bounds.width * 0.8)
                .offset(x: -15)
                
                Button {
                    tapped.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        tapped.toggle()
                    }
                } label: {
                    Text("Create Help Request").frame(maxWidth: .infinity, alignment: .center)
                }
                .padding([.leading, .trailing], 50)
                .buttonStyle(LargeRedButton(hasShadow: true))
                .rotation3DEffect(Angle(degrees: tapped ? 30 : 0), axis: (x: 0, y: -10, z: 5))
                .animation(.spring(), value: tapped)
                .onAppear {
                    tapped = true
                }

                
                Spacer().frame(height: 100)
            }
            
            Spacer()
            
            Text("*However, if the situation requires authorities - please seek relevant help.")
                .font(.footnote)
                .padding(.bottom, 40)
        }
    }
}

struct RoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Respond.")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Don't be a ...")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Rory*")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 25)
            
            Spacer()
            
            VStack {
                Image("rory")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: bounds.width)

            }
            
            Text("Never leave a friend in need. We trust you on this one. But just in case, they do receive a “rejected” status 💀")
                .padding([.leading, .trailing])
            
            Spacer()
            
            Text("* The name Rory is just a placeholder. Apologies to Rories out there.")
                .font(.footnote)
                .padding([.leading, .trailing])
                .padding(.bottom, 40)
        }
    }
}

struct HowToReachView: View {
    
    @SwiftUI.Environment(\.colorScheme) var colorScheme : ColorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("How to reach your friend:")
                    .font(.title)
                    .fontWeight(.bold)

            }
            .padding(.top, 25)
            
            Text("Sorry to disappoint, no teleportation yet.")
                .padding([.leading, .trailing])
            
            Spacer()
            
            VStack {
                Image(colorScheme == .dark ? "howToDark" : "howTo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: bounds.width * 0.95)

            }
            
            Spacer()
        }
    }
}

struct KeepUpdatedView: View {
    
    @State var tapped = false
    
    var onTap: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Make sure you keep your friend updated.")
                    .font(.title)
                    .fontWeight(.bold)

            }
            .padding(.top, 25)
            
            VStack(spacing: 12) {
                Text("Just hit “On My way” when")
                    .padding([.leading, .trailing])
                
                Text("...drumroll...")
                    .padding([.leading, .trailing])
                
                Text("you are on your way")
                    .padding([.leading, .trailing])
            }
            
            Spacer()
            
            Button {
                tapped = true
                onTap()
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                    
                    Text("On My Way")
                }
                
                .padding(10)
            }
            .buttonStyle(.bordered)
            .accentColor(.green)
            .controlSize(.large)
            
            Spacer()
        }
    }
}

struct OnboardingTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTutorialView(showTutorial: .constant(true))
    }
}
