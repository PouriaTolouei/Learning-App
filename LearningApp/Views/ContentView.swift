//
//  ContentView.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 20/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
            
                // Confirm that currentModule is set
                if model.currentModule != nil {
                    
                    ForEach(model.currentModule!.content.lessons) { lesson in
                        
                        NavigationLink {
                            ContentDetailView()
                                .onAppear {
                                    model.beginLesson(lesson.id)
                                }
                        } label: {
                            ContentViewRow(index: lesson.id)
                        }
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
        
        
    }
}
