//
//  Router.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation

typealias NavigationBackAction = (() -> Void)

protocol Router {
    func push(_ drawable: Drawable, animated: Bool, OnNavigateBack: NavigationBackAction?)
    func pop(_ animated: Bool)
    func popToRoot(_ animated: Bool)
}
