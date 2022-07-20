//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 20/07/2022.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson Card
        ZStack(alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack(spacing: 30) {
                
                Text("\(lesson.id + 1)")
                    .bold()
                    .font(.title3)
                
                
                VStack(alignment: .leading) {
                    
                    Text(lesson.title)
                        .bold()
                        .font(.title3)
                    
                    Text(lesson.duration)
                        .font(.caption)
                }
            }
            .padding(.leading, 20)
            
        }
    }
}
