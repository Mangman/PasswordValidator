//  Created by Stepan on 18/07/16.

import Foundation

class PasswordValidator: ValidatorProtocol {
    
    enum passwordIssue: ErrorType {
        case General (issueText: String)
    }
    
    var output: ValidatorOutput? = nil

    ///Проверяет пароль на правильность
    func validate(login: String, password: String) {
        do {
            
            if password.isEmpty {
                throw passwordIssue.General(issueText: "password must not be empty")
            }
            if password == login {
                throw passwordIssue.General(issueText: "password must differ from login")
            }
            if password.characters.count < 8 {
                throw passwordIssue.General(issueText: "password must be 8 characters or longer")
            }
            
            try checkPassword(password)
            
            output?.didObtainPasswordValidationResult(true, errorMsg: "")
        }
        catch passwordIssue.General(let issueText) {
            output?.didObtainPasswordValidationResult(false, errorMsg: issueText)
        }
        catch {
            output?.didObtainPasswordValidationResult(false, errorMsg: "unknown error")
        }
        
    }
    
    private func checkPassword (password: String) throws {
        let characters = Array(password.characters)
        
        var upperCaseCount = 0
        var lowerCaseCount = 0
        var numberCount    = 0
        var consecutiveCharacters = 1
        var lastLetter: Character? = nil
        
        for letter in characters {
            //  Подсчет повторяющихся символов
            checkConsecutive(letter, lastLetter: &lastLetter, consecutiveCharacters: &consecutiveCharacters)
            
            //  Подсчет цифр и букв разных регистров
            if upperCaseCount <= 0 || lowerCaseCount <= 0 || numberCount <= 0 {
                checkCases(letter, upperCaseCount: &upperCaseCount, lowerCaseCount: &lowerCaseCount, numberCount: &numberCount)
            }
            
            lastLetter = letter
        }
        if consecutiveCharacters >= 3 {
            throw passwordIssue.General(issueText: "password must have less than 3 consecutive symbols")
        }
        if upperCaseCount == 0 || lowerCaseCount == 0 {
            throw passwordIssue.General(issueText: "password must contain at least one uppercase and one lowercase character")
        }
        if numberCount == 0 {
            throw passwordIssue.General(issueText: "password must have at least one digit")
        }
    }
    
    private func checkConsecutive (letter: Character, inout lastLetter: Character?, inout consecutiveCharacters: Int){
        if letter == lastLetter {
            consecutiveCharacters += 1
        }
        else {
            consecutiveCharacters = 1
        }
    }
    
    private func checkCases (letter: Character, inout upperCaseCount: Int, inout lowerCaseCount: Int, inout numberCount: Int) {
        let letters = ["a", "b", "c", "d", "e", "f",
                       "g", "h", "i", "j", "k", "l",
                       "m", "n", "o", "p", "q", "r",
                       "s", "u", "v", "w", "x", "y", "z"]
       
        let letterString = String(letter)
        
        if letters.contains(letterString.lowercaseString) {
            if letterString.lowercaseString == letterString {
                lowerCaseCount += 1
            }
            else {
                upperCaseCount += 1
            }
        }
        else {
            numberCount += 1
        }
    }
    
}
