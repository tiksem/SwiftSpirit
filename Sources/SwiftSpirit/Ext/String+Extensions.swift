//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

extension String {
    func quoted(_ quote: String) -> String {
        quote + self + quote
    }
}