//
//  CreditManager.swift
//  Git_ Exercise
//
//  Created by sei_dev on 12/19/22.
//

import Foundation

/// creditManager의 DataFile 관련 정보들
enum DataFile {
    /// 데이터가 저장되고 로드하는 json 파일 이름
    static let name = "data.json"
    /// 파일이 저장될 Directory
    static let directory: String = FileManager.default.currentDirectoryPath
    static let pathString = DataFile.directory.appending(DataFile.name)
    static var pathUrl: URL {
        if #available(macOS 13.0, *) {
            return URL(filePath: DataFile.directory.appending(DataFile.name))
        } else {
            return URL(fileURLWithPath: DataFile.directory.appending(DataFile.name))
        }
    }
}

final class CreditManager {
    /// CreditManager - singleton
    static let shared = CreditManager()
    private init() { }
    
    /// CreditManager의 현재 status
    private var status: Status = .start
    /// CreditManager에 등록된 Student의 List
    private var students = [Student]()
    
    func run() {
    }
    
    /// status 별 input parse
    private func parse(input: String) throws -> ParsedInput {
        guard let parsedInput = status.parse(input: input) else {
            throw status == .start ? CMError.invalidStartInput : IOError.wrongInput
        }
        return parsedInput
    }
}

//MARK: - Start

extension CreditManager {
    /// 입력에 따라 credit manager의 status 변경
    private func start(_ input: ParsedInput) throws {
        guard let nextStatus = input[0] as? Status else {
            throw CMError.invalidStartInput
        }
        guard nextStatus != .exit else {
            throw CMError.quitProgram
        }
        guard [Status.start, Status.addStudent].contains(nextStatus) || false == students.isEmpty else {
            throw CMError.emptyStudents
        }
        self.status = nextStatus
    }
}

//MARK: - AddStudent

extension CreditManager {
    /// 입력받은 학생을 students에 추가
    ///
    /// Error occurs when
    /// - 입력받은 학생이 이미 존재
    private func add(student input: ParsedInput) throws {
        guard let name = input[0] as? String else {
            throw IOError.wrongInput
        }
        guard false == exists(student: name) else {
            throw CMError.studentAleadyExists(name: name)
        }
        let student = Student(name: name)
        students.append(student)
    }
    
    /// 학생이 등록되어 있다면 true
    private func exists(student name: String) -> Bool {
        return students.contains { $0.name == name }
    }
}

//MARK: - Delete Student

extension CreditManager {
    /// 입력받은 학생을 students에서 삭제
    ///
    /// Error occurs when
    /// - 등록된 학생이 0명
    /// - 입력받은 학생이 존재하지 않음
    private func delete(student input: ParsedInput) throws {
        guard false == students.isEmpty  else {
            throw CMError.emptyStudents
        }
        guard let name = input[0] as? String else {
            throw IOError.wrongInput
        }
        guard exists(student: name) else {
            throw CMError.studentNotFound(name: name)
        }
        students.removeAll { $0.name == name }
    }
}
