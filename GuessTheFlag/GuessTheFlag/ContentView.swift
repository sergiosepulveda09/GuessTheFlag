//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sergio Sepulveda on 2021-06-10.
//

import SwiftUI

struct ContentView: View {
    
    //Variables
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
                        flagTapped(for: number)
                    }, label: {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: .black, radius: 2)
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
        } else {
            self.scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        self.showingScore = true
    }
    
    //Ask to continue playing
    func askQuestion() {
        self.countries.shuffle()
        self.correctAnswer = Int.random(in: 0...2)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
