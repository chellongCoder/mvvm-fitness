//
//  AddActivityController.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation
import UIKit
import SwiftUI

class AddActivityController: UIViewController {
  private var email: String = ""

  private var emailInputView: EmailInputView!
  private let headerView = NavigationBarView()
  private let inputLinkView = InputLinkView()
  private let videoView = VideoPlayerView()
  private var buttonView: CustomButtonView? = nil

 private let actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Add Activity", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 20
    button.translatesAutoresizingMaskIntoConstraints = false

    // Set image
    let plusImage = UIImage(systemName: "plus") // Use SF Symbols or your custom image
    button.setImage(plusImage, for: .normal)
    button.tintColor = .white
    
    // Adjust image and title position
    button.titleLabel?.textAlignment = .center
   button.imageView?.semanticContentAttribute = .forceRightToLeft

    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
         
    return button
}()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    emailInputView = EmailInputView(email: Binding(
      get: { self.email },
      set: { self.email = $0 }
    ))
    buttonView = CustomButtonView(onClick: { [weak self] in
      let email = self?.email
      print("email: \(email ?? "")")
    })

    setupEmailInputView()


 }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Hide the default navigation bar
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      // Show the navigation bar on other view controllers
      self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }


   private func setupEmailInputView() {
     let hostingController = UIHostingController(rootView: headerView)
     let emailController = UIHostingController(rootView: emailInputView)
     let linkController = UIHostingController(rootView: inputLinkView)
     let videoController = UIHostingController(rootView: videoView)
     let buttonController = UIHostingController(rootView: buttonView)

     addChild(hostingController)
     addChild(emailController)
     addChild(linkController)
     addChild(videoController)
     addChild(buttonController)
     view.addSubview(hostingController.view)
     view.addSubview(emailController.view)
     view.addSubview(linkController.view)
     view.addSubview(videoController.view)
     view.addSubview(buttonController.view)


     hostingController.view.translatesAutoresizingMaskIntoConstraints = false
     emailController.view.translatesAutoresizingMaskIntoConstraints = false
     linkController.view.translatesAutoresizingMaskIntoConstraints = false
     videoController.view.translatesAutoresizingMaskIntoConstraints = false
     buttonController.view.translatesAutoresizingMaskIntoConstraints = false

     NSLayoutConstraint.activate([
         hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
         hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         hostingController.view.heightAnchor.constraint(equalToConstant: 50),

         // EmailInputView constraints
         emailController.view.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor, constant: 10),
         emailController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         emailController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

         // LinkController constraints
         linkController.view.topAnchor.constraint(equalTo: emailController.view.bottomAnchor, constant: 10),
         linkController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         linkController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

         // VideoController constraints
         videoController.view.topAnchor.constraint(equalTo: linkController.view.bottomAnchor, constant: 10),
         videoController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         videoController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),



          // ActionButton constraints
         buttonController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         buttonController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         buttonController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
     ])

     hostingController.didMove(toParent: self)

     
   }
}
