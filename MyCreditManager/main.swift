//
//  main.swift
//  MyCreditManager
//
//  Created by 김정태 on 2023/04/18.
//

import Foundation

let mainMessage = "원하는 기능을 입력해주세요 \n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료"
let errorMessage = "뭔가 입력이 잘못되었습니다. 1~5사이의 숫자혹은 X를 입력해주세요."
let emptyErrorMessage = "입력이 잘못되었습니다. 다시 확인해주세요."
let addStudentMessage = "추가할 학생의 이름을 입력해주세요"
let deleteStudentMessage = "삭제할 학생의 이름을 입력해주세요"
let noFoundDeleteStudentMessage = "학생을 찾지 못하였습니다."
let alreadyStudentMessage = "이미 존재하는 학생입니다. 추가하지 않습니다."
let addStudentAnswer = "학생을 추가했습니다."
let deleteStudentAnswer = "학생을 삭제하였습니다."
let addStudentSubjectScore = "성적을 추가할 학생의 이름, 과목이름, 성적(A+, A, F)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력 예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다."
let deleteStudentSubjectScore = "성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요."
let showScoreMessage = "평점을 알고싶은 학생의 이름을 입력해주세요."

struct Student {
    var name: String
    var subject_score: [Dictionary<String, String>]?
}


var num: String? = ""
var student = [Student]()

while num != "X" {
    print(mainMessage)
    num = readLine()
    
    switch num {
    case "1":
        addStudent()
        print(student, "학생확인")
    case "2":
        deleteStudent()
        print(student, "학생확인")
    case "3":
        editScore()
        print(student, "학생확인")
    case "4":
        deleteScore()
        print(student, "학생확인")
    case "5":
        showScore()
        print(student, "학생확인")
    case "X":
        num = "X"
        print("프로그램을 종료합니다...")
        
    default:
        print(errorMessage)
    }
}

//MARK: 학생추가
func addStudent() {
    
    var studentName: String? = ""
    print(addStudentMessage)
    
    studentName = readLine()
    
    // 빈값 확인
    if studentName == "" {
        print(emptyErrorMessage)
        
    // 중복 제거
    } else if !student.filter({ $0.name == studentName }).isEmpty {
        print("\(studentName!)는 \(alreadyStudentMessage)")
        
    // 학생 추가
    } else {
        print("\(studentName!) \(addStudentAnswer)")
        student.append(Student(name: studentName!))
    }
    
}

//MARK: 학생삭제
func deleteStudent() {
    var studentName: String? = ""
    print(deleteStudentMessage)
    
    studentName = readLine()
    
    // 빈값 확인
    if studentName == "" {
        print(emptyErrorMessage)
        
    // 추가 되어있는지 확인
    } else if student.filter({ $0.name == studentName }).isEmpty {
        print("\(studentName!) \(noFoundDeleteStudentMessage)")
        
    // 학생 삭제
    } else {
        print("\(studentName!) \(deleteStudentAnswer)")
        student.removeAll(where: { $0.name == studentName })
    }
}

//MARK: 성적추가(변경)
func editScore() {
    print(addStudentSubjectScore)
    guard let input = readLine(), !input.isEmpty else {
        print(emptyErrorMessage)
        return
    }
    
    let inputArray = input.split(separator: " ")
    guard inputArray.count == 3 else {
        print(emptyErrorMessage)
        return
    }
    
    let name = String(inputArray[0])
    let subject = String(inputArray[1])
    let score = String(inputArray[2])
    
    guard let studentIndex = student.firstIndex(where: { $0.name == name }) else {
        print("\(name) \(noFoundDeleteStudentMessage)")
        return
    }
    
    if let subjectIndex = student[studentIndex].subject_score?.firstIndex(where: { $0[subject] != nil }) {
        // 이미 존재하는 과목의 경우 해당 점수로 업데이트
        student[studentIndex].subject_score?[subjectIndex][subject] = score
    } else {
        // 새로운 과목과 점수 추가
        let newSubject = [subject: score]
        if student[studentIndex].subject_score == nil {
            student[studentIndex].subject_score = [newSubject]
        } else {
            student[studentIndex].subject_score?.append(newSubject)
        }
        
        print("\(name)학생의 \(subject)과목이 \(score)로 추가(변경)되었습니다.")
    }
}

//MARK: 성적 삭제
func deleteScore() {
    print(deleteStudentSubjectScore)
    guard let input = readLine(), !input.isEmpty else {
        print(emptyErrorMessage)
        return
    }
    
    let inputArray = input.split(separator: " ")
    guard inputArray.count == 2 else {
        print(emptyErrorMessage)
        return
    }
    
    let name = String(inputArray[0])
    let subject = String(inputArray[1])
    
    // 이름이 저장되어 있는지 확인
    if let studentIndex = student.firstIndex(where: { $0.name == name }) {
        
        // 과목을 듣고 있는지 확인
        if let subjectIndex = student[studentIndex].subject_score?.firstIndex(where: { $0.keys.first == subject }) {
            student[studentIndex].subject_score?.remove(at: subjectIndex)
            print("\(name) 학생의 \(subject) 과목 점수가 삭제되었습니다.")
        } else {
            print("\(name) 학생은 \(subject) 과목을 수강하지 않았습니다.")
        }
        
    } else {
        print("\(name) \(noFoundDeleteStudentMessage)")
    }

}

//MARK:
func showScore() {
    print(showScoreMessage)
    
    var totalScore = 0.0
    guard let input = readLine(), !input.isEmpty else {
        print(emptyErrorMessage)
        return
    }
    
    guard let studentIndex = student.firstIndex(where: { $0.name == input }) else {
        print("\(input) \(noFoundDeleteStudentMessage)")
        return
    }
    
    student[studentIndex].subject_score?.forEach {
        print("\($0.keys.first!): \($0.values.first!)")
        
        
        switch $0.values.first! {
        case "A+":
            totalScore += 4.5
        case "A":
            totalScore += 4.0
        case "B+":
            totalScore += 3.5
        case "B":
            totalScore += 3.0
        case "C+":
            totalScore += 2.5
        case "C":
            totalScore += 2.0
        case "D+":
            totalScore += 1.5
        case "D":
            totalScore += 1.0
        default:
            totalScore += 0.0
        }
        
    }
    
    print(totalScore / Double(student[studentIndex].subject_score!.count))
    
    
}

