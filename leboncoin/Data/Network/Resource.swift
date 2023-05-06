//
//  Resource.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
    var request: URLRequest {
        return URLRequest(url: url)
    }
}
