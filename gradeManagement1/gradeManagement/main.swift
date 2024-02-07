//
//  main.swift
//  gradeManagement
//
//  Created by StudentAM on 1/23/24.
//

import Foundation
import CSV

//variable that keeps track of the user's main choice
var choice: String = "0"

//the arrays that hold the student's data
var gradeAverages: [Double] = []
var allGrades: [[String]] = []
var studentNames: [String] = []

//reading the csv file to add elements to allGrades array and the studentNames array
//the corresponding data will be in the same indices as eachother because it is getting read line by line
do{
    let stream = InputStream(fileAtPath:"/Users/studentam/Desktop/gradeManagement/gradeManagement/grades.csv")
    
    let csv = try CSVReader(stream: stream!)
    
    while var row = csv.next(){
        
        let tempName: String = row[0]
        studentNames.append(tempName)
        
        row.removeFirst()
        allGrades.append(row)
    }
}
catch{
    print("There was an error trying to read the file!")
}

//adding the element to the gradeAverage array
//the corresponding data wil be in the same indices as eachother because it is going through all grades array
for i in 0...(allGrades.count - 1){
    var sum: Double = 0
    
    for j in 0...(allGrades[i].count - 1){
        sum += Double(allGrades[i][j])!
    }
    
    var theGPA: Double = round(100*sum/10)/100
    gradeAverages.append(theGPA)
}

//function for getting the student name (for formating answer)
func getName(_ name:String) -> String{
    for i in 0...(studentNames.count - 1){
        if name.lowercased() == studentNames[i].lowercased(){
            return studentNames[i]
        }
    }
    //for if the name the user entered is not in the studentNames array
    return "The name entered is not in the gradebook."
}

//function for returning the indices of the student to get the corresponding data
func getIndices(_ name:String) -> Int?{
    for i in 0...(studentNames.count - 1){
        if name.lowercased() == studentNames[i].lowercased(){
            return i
        }
    }
    //for if the student entered is not in the studentNames array
    return nil
}

//function that checks if a string can be converted into a integer/double
func isNumber(_ input:String) -> Bool{
    let allNums = ".0123456789"
    
    for char in input{
        if !allNums.contains(char){
            return false
        }
    }
    return true
}

//function for returning all of the elements in a 2D array for one of the indices
func getStudentAllGrades(_ index: Int) -> String{
    var theString = ""
    for i in 0...(allGrades[index].count - 1){
        if i == 0{
            theString += "\(allGrades[index][i])"
        }
        else{
            theString += ", \(allGrades[index][i])"
        }
        
    }
    return theString
}

while choice != "9"{
    print("Welcome to the Grade Manager!")
    
    print("What would you like to do?(Enter the number):")
    print("1. Display grade of a single student")
    print("2. Display all grades for a student")
    print("3. Display all grades of ALL students")
    print("4. Find the average grade of the class")
    print("5. Find the average grade of an assignment")
    print("6. Find the lowest grade in the class")
    print("7. Find the highest grade of the class")
    print("8. Filter students by grade range")
    print("9. Quit")
    
    //checks if the next line is valid/exists
    if let userChoice = readLine(){
        //assigns the user input as a string to the variable choice
        choice = userChoice
        
        //for if the user entered "1"//if the user wants to see the overall grade of one student
        if choice == "1"{
            print("Which student would you like to choose?")
            
            if let theStudent = readLine(){
                if let theIndex: Int = getIndices(theStudent){
                    print("\(getName(theStudent))'s overall grade in the class is \(gradeAverages[theIndex])")
                }
                //for if the name the user entered in not in the studentNames array
                else{
                    print("That student is not in the grade book")
                }
            }
        }
        
        //for if the user enetered "2"//if the user wants to see all grades of one student
        else if choice == "2"{
            print("Which student would you like to choose?")
            
            if let theStudent = readLine(){
                if let theIndex: Int = getIndices(theStudent){
                    print("\(getName(theStudent))'s grades for this class are")
                    
                    print(getStudentAllGrades(theIndex))
                }
                //for if the name the user entered in not in the studentNames array
                else{
                    print("That student is not in the grade book")
                }
            }
        }
        
        //for if the user entered "3" // if the user wants to see all grades for all students
        else if choice == "3"{
            for i in 0...(studentNames.count - 1){
                print("\(studentNames[i])'s grades are: \(getStudentAllGrades(i))")
            }
        }
        
        //for if the user entered "4" // if the user wants to see the average grade of the class
        else if choice == "4"{
            var sum: Double = 0;
            
            for i in 0...(gradeAverages.count - 1){
                sum += gradeAverages[i]
            }
            
            var classAverage: Double = round(100*sum/Double(studentNames.count))/100
            print("The class average is: \(classAverage)")
        }
        
        //for if the user entered "5" // if the user wants to find the average grade of an assignment
        else if choice == "5"{
            print("Which assignment would you like to get the average of (1-10):")
            
            if let assignment = readLine(){
                if isNumber(assignment){
                    if assignment.contains("."){
                        print("Invalid assignment number")
                    }
                    else{
                        var sum: Double = 0.0
                        var index: Int = Int(assignment)! - 1
                        
                        //for if the assignment the user entered is not valid
                        if index > 9 || index < 0{
                            print("Sorry, that assignment is not in the grade book")
                        }
                        else{
                            for i in 0...(allGrades.count - 1){
                                sum += Double(allGrades[i][index])!
                            }
                            
                            var theAverage: Double = round(100*sum/Double(studentNames.count))/100
                            print("The average for assignment #\(assignment) is \(theAverage)")
                        }
                    }
                }
                //for if the user input is not valid
                else{
                    print("Sorry, that is not a valid answer")
                }
            }
        }
        //for if the user entered "6" // if the user wants to find the student with the lowest grade
        else if choice == "6"{
            var lowestIndex: Int = 0
            
            for i in 1...(gradeAverages.count - 1){
                if gradeAverages[i] < gradeAverages[lowestIndex]{
                    lowestIndex = i
                }
            }
            
            print("\(studentNames[lowestIndex]) is the student with the lowest grade: \(gradeAverages[lowestIndex])")
        }
        //for if the user entered "7" // if the user wants to find the student with the highest grade
        else if choice == "7"{
            var highestIndex: Int = 0
            
            for i in 1...(gradeAverages.count - 1){
                if gradeAverages[i] > gradeAverages[highestIndex]{
                    highestIndex = i
                }
            }
            
            print("\(studentNames[highestIndex]) is the student with the highest grade: \(gradeAverages[highestIndex])")
        }
        //for if the user entered "8" // if the user wants to get all of the grades in the range of what they entered
        else if choice == "8"{
            print("Enter the lower bound you would like to use: ")
            
            if let lowerBound = readLine(){
                if isNumber(lowerBound){
                    print("Enter the upper bound you would like to use: ")
                    
                    if let upperBound = readLine(){
                        if !isNumber(upperBound) || upperBound <= lowerBound{
                            print("Invalid upper bound")
                        }
                        else{
                            for i in 0...(gradeAverages.count - 1){
                                if gradeAverages[i] > Double(lowerBound)! && gradeAverages[i] < Double(upperBound)!{
                                    print("\(studentNames[i]): \(gradeAverages[i])")
                                }
                            }
                        }
                    }
                }
                //for if the input is invalid
                else{
                    print("Invalid lower bound")
                }
            }
        }
        //for if the user entered "9" // if the user wants to quit the application
        else if choice == "9"{
            print("The Grade Manager has been closed. Have a great rest of your day!")
        }
        //for if the input is invalid
        else{
            print("Invalid option")
        }
        //this line is for spacing the displayed text evenly to separate the messages
        print()
    }
    
}
