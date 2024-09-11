//
//  AddActivityController.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class AddActivityController: UIViewController {
  private var email: String = ""
  private var ytLink: String = "" {
    didSet {
      self.updateSlider()
    }
  }

  var videoController: UIHostingController<VideoPlayerView>!

  var observableSlider:ObservableSlider = ObservableSlider()
  private var cancellables: Set<AnyCancellable> = []

  private var emailInputView: EmailInputView!
  private let headerView = NavigationBarView()
  private var inputLinkView: InputLinkView!
  private var videoView: VideoPlayerView!
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
    inputLinkView = InputLinkView(link: Binding(
      get: { self.ytLink },
      set: { self.ytLink = $0 }
    ))
    videoView = VideoPlayerView(ytLink: Binding(
      get: { self.ytLink },
      set: { self.ytLink = $0 }
    ))
    buttonView = CustomButtonView(onClick: { [weak self] in
      let email = self?.email
      print("email: \(email ?? "")")
      guard let isValidYt = self?.ytLink.isValidYouTubeLink() else {
        return
      }
      let item = ExerciseModel(exerciseName: email ?? "Untitled", ytLink: "https://youtube.com/pushup", createdAt: Date())
      UserDefaultsManager.shared.pushObject(item)

      // Show toast message
      self?.showToast(message: "Exercise added successfully!")

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


  func updateSlider() {
      observableSlider.value = 8.5
  }

   private func setupEmailInputView() {
     let hostingController = UIHostingController(rootView: headerView)
     let emailController = UIHostingController(rootView: emailInputView)
     let linkController = UIHostingController(rootView: inputLinkView)
     videoController = UIHostingController(rootView: videoView)
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

     self.observableSlider.$value.assign(to: \.observableSlider.value, on: self.videoController.rootView).store(in:&self.cancellables)

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


extension AddActivityController {
  // Function to show toast message
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}