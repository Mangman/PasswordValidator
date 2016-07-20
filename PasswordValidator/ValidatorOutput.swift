//  Created by Stepan on 18/07/16.

import Foundation

protocol ValidatorOutput {
    func didObtainPasswordValidationResult (result: Bool, errorMsg: String?)
}