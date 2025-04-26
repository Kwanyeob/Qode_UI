//
//  LoginViewController.swift
//  Qode
//
//  Created by David Lee on 4/8/25.
//
/*
 UIKit
 import UIKit
 import GoogleSignIn
 import AuthenticationServices

 class LoginViewController: UIViewController, LoginViewProtocol {
     private var presenter: LoginPresenter!
     private var usernameField: UITextField!
     private var passwordField: UITextField!

     override func viewDidLoad() {
         super.viewDidLoad()
         presenter = LoginPresenter(view: self, authService: AuthService())
         setupUI()
     }

     private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
         let tf = UITextField()
         tf.placeholder = placeholder
         tf.isSecureTextEntry = isSecure
         tf.borderStyle = .roundedRect
         tf.autocapitalizationType = .none
         tf.autocorrectionType = .no
         tf.translatesAutoresizingMaskIntoConstraints = false
         return tf
     }

     private func createSocialButton(title: String, image: UIImage?, style: SocialButtonStyle, action: Selector) -> UIButton {
         let icon = UIImageView(image: image)
         icon.translatesAutoresizingMaskIntoConstraints = false
         icon.contentMode = .scaleAspectFit
         icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
         icon.heightAnchor.constraint(equalToConstant: 20).isActive = true

         let label = UILabel()
         label.text = title
         label.font = .systemFont(ofSize: 16, weight: .medium)
         label.textColor = (style == .apple) ? .white : .darkGray

         let stack = UIStackView(arrangedSubviews: [icon, label])
         stack.axis = .horizontal
         stack.spacing = 12
         stack.alignment = .center
         stack.translatesAutoresizingMaskIntoConstraints = false

         let button = UIButton(type: .system)
         button.addSubview(stack)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.layer.cornerRadius = 10
         button.heightAnchor.constraint(equalToConstant: 44).isActive = true
         button.backgroundColor = (style == .apple) ? .darkGray : .white
         button.tintColor = (style == .apple) ? .white : .darkGray
         button.layer.borderWidth = (style == .google) ? 1 : 0
         button.layer.borderColor = (style == .google) ? UIColor.systemGray4.cgColor : nil
         button.addTarget(self, action: action, for: .touchUpInside)

         NSLayoutConstraint.activate([
             stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
             stack.centerYAnchor.constraint(equalTo: button.centerYAnchor)
         ])

         return button
     }

     enum SocialButtonStyle { case google, apple }

     private func setupUI() {
         view.backgroundColor = .white

         let logo = UIImageView(image: UIImage(systemName: "photo"))
         logo.contentMode = .scaleAspectFit
         logo.tintColor = .gray
         logo.translatesAutoresizingMaskIntoConstraints = false
         logo.heightAnchor.constraint(equalToConstant: 80).isActive = true

         let title = UILabel()
         title.text = "Welcome to Qode"
         title.font = .boldSystemFont(ofSize: 28)
         title.textAlignment = .center

         let subtitle = UILabel()
         subtitle.text = "Enter your username and password\nto login"
         subtitle.font = .systemFont(ofSize: 14)
         subtitle.textColor = .gray
         subtitle.numberOfLines = 2
         subtitle.textAlignment = .center

         usernameField = createTextField(placeholder: "Username")
         passwordField = createTextField(placeholder: "Password", isSecure: true)

         let forgotButton = UIButton(type: .system)
         forgotButton.setTitle("Forgot Password?", for: .normal)
         forgotButton.titleLabel?.font = .systemFont(ofSize: 12)
         forgotButton.setTitleColor(.gray, for: .normal)
         forgotButton.contentHorizontalAlignment = .right

         let loginButton = UIButton(type: .system)
         loginButton.setTitle("Login", for: .normal)
         loginButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
         loginButton.backgroundColor = .darkGray
         loginButton.setTitleColor(.white, for: .normal)
         loginButton.layer.cornerRadius = 8
         loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
         loginButton.addTarget(self, action: #selector(handleEmailLogin), for: .touchUpInside)

         let orLabel = UILabel()
         orLabel.text = "Or login in with"
         orLabel.font = .systemFont(ofSize: 12)
         orLabel.textColor = .gray
         orLabel.textAlignment = .center

         let googleButton = createSocialButton(title: "Google", image: UIImage(named: "GoogleLogo")?.withRenderingMode(.alwaysTemplate), style: .google, action: #selector(handleGoogleLogin))
         let appleButton = createSocialButton(title: "Apple", image: UIImage(systemName: "applelogo"), style: .apple, action: #selector(handleAppleLogin))

         let socialStack = UIStackView(arrangedSubviews: [googleButton, appleButton])
         socialStack.axis = .horizontal
         socialStack.spacing = 12
         socialStack.distribution = .fillEqually

         let register = UILabel()
         register.text = "Don't have an account? Register"
         register.font = .systemFont(ofSize: 13)
         register.textAlignment = .center

         let help = UILabel()
         help.text = "Need help? Visit our help center"
         help.font = .systemFont(ofSize: 12)
         help.textColor = .gray
         help.textAlignment = .center

         let stack = UIStackView(arrangedSubviews: [logo, title, subtitle, usernameField, passwordField, forgotButton, loginButton, orLabel, socialStack, register, help])
         stack.axis = .vertical
         stack.spacing = 16
         stack.alignment = .fill
         stack.translatesAutoresizingMaskIntoConstraints = false

         view.addSubview(stack)
         NSLayoutConstraint.activate([
             stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
             stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
             stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
     }

     @objc private func handleEmailLogin() {
         let username = usernameField.text ?? ""
         let password = passwordField.text ?? ""
         presenter.loginWithEmail(username: username, password: password)
     }

     @objc private func handleGoogleLogin() {
         presenter.loginWithGoogle(presentingVC: self)
     }

     @objc private func handleAppleLogin() {
         presenter.loginWithApple(presentationProvider: self, delegate: self)
     }

     func showError(_ message: String) {
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }

     func goToHomeScreen() {
         let tabBarController = MainTabBarController()
         guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
         sceneDelegate.window?.rootViewController = tabBarController
     }
 }

 extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         presenter.view?.goToHomeScreen()
     }

     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
         presenter.view?.showError(error.localizedDescription)
     }

     func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
     }
 }

 #Preview {
     LoginViewController()
 }
 */
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var presenter = LoginPresenter()
    @State private var showForgotSheet = false
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Logo
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.gray)
                    Text("LOGO")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                // MARK: - Title
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Enter your username and password\nto login")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                // MARK: - Text Fields
                TextField("Username", text: $presenter.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $presenter.password)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        showForgotSheet = true
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showForgotSheet) {
                        ForgotPasswordSheet()
                    }
                }
                
                // MARK: - Login Button
                Button(action: {
                    presenter.loginWithEmail()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // MARK: - Divider Text
                Text("Or login in with")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: - Social Login Buttons
                HStack(spacing: 12) {
                    // Google 버튼
                    Button(action: presenter.loginWithGoogle) {
                        HStack(spacing: 8) {
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                            Text("Google")
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(Color(.darkGray))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }
                    
                    // Apple 버튼
                    Button(action: {
                        presenter.loginWithAppleManually()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 24))
                                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                            Text(" Apple")
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                // MARK: - Register
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    Button(action: {
                        showRegister = true
                    }) {
                        Text("Register")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.darkGray))
                    }
                }
                .padding(.bottom, 16)
                .navigationDestination(isPresented: $showRegister) {
                    RegisterView()
                }
                
                // MARK: - Help
                Text("Need help? Visit our ")
                    .font(.caption2)
                    .foregroundColor(.gray)
                + Text("help center")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 40)
            .alert(isPresented: .constant(presenter.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(presenter.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $presenter.isLoggedIn) {
                MainTabBarView()
            }
        }
    }
}

#Preview {
    LoginView()
}
