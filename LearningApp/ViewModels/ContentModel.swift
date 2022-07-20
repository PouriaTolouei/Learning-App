//
//  ContentModel.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 16/07/2022.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentIndex = 0
    
    var styleData: Data?
    
    init() {
        self.getLocalData()
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        
        // Parse the local data
        
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
        
        // Parse the style data
        
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
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int)  {
        
        // Find the index for this module id
        if let i = modules.firstIndex(where: {$0.id == moduleid}) {
            
            // Found the matching module
            currentIndex = i
            
            // Set the current module
            currentModule = modules[currentIndex]
        }
    }
}
