//
//  TestView.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 27/07/2022.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numeCorrect = 0
    @State var isSubmitted = false
    
    var body: some View {
        if let question = model.currentQuestion {
            VStack(alignment: .leading) {
                // Question number
                Text("Question \(question.id + 1 ) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0..<question.answers.count) { index in
                            
                            Button {
                                // Track the selected index
                               selectedAnswerIndex = index
                                
                            } label: {
                                ZStack {
                                    if !isSubmitted {
                                        
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    // Answer has been submitted
                                    else {
                                        
                                        // When the button is the selected answer
                                        if index == selectedAnswerIndex {
                                            
                                            // Shows a green background if it's correct, otherwise shows a red background
                                            RectangleCard(color: index == question.correctIndex ? .green : .red)
                                                .frame(height: 48)
                                        }
                                        
                                        // When the button is not the selected answer
                                        else {
                                            
                                            // Shows a green background if it's correct, otherwise shows a white background
                                            RectangleCard(color: index == question.correctIndex ? .green : .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(question.answers[index])
                                }
                            }
                            .disabled(isSubmitted)
                        }
                    }
                    .tint(.black)
                    .padding()        
                }
                
                // Submit Button
                Button {
                    
                    // Change submitted state to true
                    isSubmitted = true
                    
                    // Check the answer and increment the counter if correct
                    if selectedAnswerIndex == question.correctIndex {
                        numeCorrect += 1
                    }
                    
                } label: {
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Submit")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .disabled(selectedAnswerIndex == nil)

            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test hasn't loaded yet
            ProgressView()
        }
    }
}

