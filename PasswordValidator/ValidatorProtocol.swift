//  Created by Stepan on 18/07/16.

import UIKit

protocol ValidatorProtocol {
    var output: ValidatorOutput? { get set }
    func validate (login: String, password: String)
}
