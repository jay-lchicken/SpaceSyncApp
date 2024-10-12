//
//  Extensions.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import Foundation

extension Encodable{
    func asDictionary() -> [String:Any]{
        guard let data = try? JSONEncoder().encode(self) else{
            return[:]
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
            return json ?? [:]
        }catch{
            return[:]
        }
    }
}
