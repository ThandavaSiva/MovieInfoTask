//
//  FoundationAddations.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

extension Data {
    
    func toJSONObject() -> Any? {
        
        let object = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
        return object
    }
}


extension Dictionary {
    
    func toJSONData() -> Data? {
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
}
