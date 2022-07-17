//
//  ContentModel.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 16/07/2022.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    var styleData: Data?
    
    init() {
        self.getLocalData()
    }
    
    func getLocalData() {
        
        //MARK: Parse the local data
        
        // Get a URL to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // Log error
            print("Couldn't parse local data.")
        }
        
        // MARK: Parse the style data
        
        // Get a URL to the html file
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse  style data.")
        }
        
        
    }
}
