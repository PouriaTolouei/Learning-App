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
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current attributed text
    @Published var codeText: NSAttributedString?
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init() {
        getLocalData()
        
        getRemoteData()
    }
    
    // MARK: - Data methods
    
    // Parse local included json data
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
    
    // Download remote json file and parsa data
    func getRemoteData() {
        
        // String path
        let urlString = "https://pouriatolouei.github.io/learningapp-data/data2.json"
        
        // Create a url object
        let url =  URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there's an error
            guard error == nil else {
                return
            }
            
            // Create json decoder
            let decoder = JSONDecoder()
            
            // Decode
            do {
                let modules =  try decoder.decode([Module].self, from: data!)
                
                // Apped parsed modules into modules property
                self.modules += modules
            }
            catch {
                // Couldn't parse json
                print(error)
            }
            
        }
        
        // Kick off the data task
        dataTask.resume()    
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int)  {
        
        // Find the index for this module id
        if let i = modules.firstIndex(where: {$0.id == moduleid}) {
            
            // Found the matching module
            currentIndex = i
        }
        else {
            currentIndex = 0
        }
        
        // Set the current module
        currentModule = modules[currentIndex]
    }
    
    func beginLesson(_ lessonid: Int) {
        
        // Find the index for this lesson id
        if let i = currentModule!.content.lessons.firstIndex(where: {$0.id == lessonid}) {
            
            // Found the matchnig lesson
            currentLessonIndex = i
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addstyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson properity
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addstyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLesson = nil
            currentLessonIndex = 0
            codeText = nil
        }
        
        
    }
    
    func hasNextLesson() -> Bool {
        
       return(currentLessonIndex < currentModule!.content.lessons.count - 1)
    }
    
    func beginTest(_ moduleId: Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // If there are questions, set the current question to the first one (default index of 0)
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addstyling(currentQuestion!.content)
        }
        else {
            currentQuestionIndex = 0
        }
        
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the code text
            codeText = addstyling(currentQuestion!.content)
        }
        else {
            
            // If not, reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
            codeText = nil
            
        }
    }
    
    func hasNextQuestion() -> Bool {
        return (currentQuestionIndex < currentModule!.test.questions.count - 1)
    }
    
    // MARK: - Code styling
    
    private func addstyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed String
        
        // Technique 1
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        /*
        // Technique 2
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            resultString = attributedString
            
        }
        catch {
            print("Couldn't turn html into attributed string.")
        }
         */
        
        
        return resultString
    }
}
