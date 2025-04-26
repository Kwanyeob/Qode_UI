//
//  LoginViewProtocol.swift
//  Qode
//
//  Created by David Lee on 4/10/25.
//

protocol LoginViewProtocol: AnyObject {
    func showError(_ message: String)
    func goToHomeScreen()
}
