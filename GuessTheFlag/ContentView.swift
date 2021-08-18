//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sergio Sepulveda on 2021-06-10.
//

import SwiftUI

struct ContentView: View {
    
    //Variables
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries: [String] = ["Estonia","France",
                                              "Germany","Ireland",
                                              "Italy","Nigeria",
                                              "Poland","Russia",
                                              "Spain", "UK", "US"]
        .shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var userScore: Int = 0
    @State private var animationAmount: Double = 0.0
    @State private var animate: Bool = false
    @State private var animateWrong: Bool = false
    //Body view
    var body: some View {
        
        ZStack{
            
            //Background
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                //Text
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                //Flags
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                            flagTapped(for: number)
                            self.animationAmount += 360
                        }
                    }, label: {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: .black, radius: 2)
                            
                            .rotation3DEffect(.degrees(number == correctAnswer && animate ? animationAmount : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
//                            .offset()
                            .animation(
                                showingScore ? Animation.spring(response: 1, dampingFraction: 30, blendDuration: 0) : .easeInOut
                            )
                            .opacity(number != correctAnswer && animate ? 0.5 : 1)
                            .animation(.spring())
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                        
                    })
                }
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        })
    }
    //Check whether the flag and the answer match or not
    func flagTapped(for number: Int) {
        if number == correctAnswer {
            self.scoreTitle = "Correct"
            self.userScore += 1
            self.animate = true
            
        } else {
            self.scoreTitle = "Wrong! That's the flag of \(countries[number])"
            self.animateWrong = true
        }
        self.showingScore = true
    }
    
    //Ask to continue playing
    func askQuestion() {
        self.countries.shuffle()
        self.correctAnswer = Int.random(in: 0...2)
        self.animate = false
        self.animationAmount = .zero
        self.animateWrong = false
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
