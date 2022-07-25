//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 21/07/2022.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            
            // Only show video if we get a valid url
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // TODO: Description
            CodeTextView()
            
            // Show next lesson button, only if there's a next lesson
            if model.hasNextLesson() {
                
                Button {
                    // Advance the lesson
                    model.nextLesson()
                } label: {
                    ZStack {
                        RectangleCard(color:.green)
                            .frame(height: 48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
            // Showsthe complete button, if it's the last lesson
            else {
                
                Button {
                    // Take the user back to the homeView
                    model.currentContentSelected = nil
                } label: {
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
            
            

        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
        
    }
}
