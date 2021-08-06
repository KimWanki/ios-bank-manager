//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let yagomBank = BankManager()
    
    //MARK: --- Interface
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let makeButton: (String, UIColor, Selector) -> UIButton = { (title: String, Color: UIColor, function: Selector ) in
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.addTarget(self, action: function, for: .touchUpInside)
        button.setTitleColor(Color, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        return button
    }
    
    let stateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "업무시간 - 00:00:000"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    let makeLabel: (String, UIColor) -> UILabel = { (text: String, Color: UIColor) in
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.backgroundColor = Color
        return label
    }
    
    let waitingScollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let waitingContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    let processingScollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let processingContentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUpUI()
    }
    
    var count = 0
    
    func setUpUI() {
        view.addSubview(mainStackView)
        
        mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        let lineUpButton = makeButton("고객 10명 추가", .systemBlue, #selector(addTenClients))
        let initButton = makeButton("초기화", .systemRed, #selector(initQueue))
        
        buttonStackView.addArrangedSubview(lineUpButton)
        buttonStackView.addArrangedSubview(initButton)
    
        let waitingLabel = makeLabel("대기중", .systemGreen)
        let servingLabel = makeLabel("업무중", .systemPurple)

        stateStackView.addArrangedSubview(waitingLabel)
        stateStackView.addArrangedSubview(servingLabel)
        
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(durationLabel)
        mainStackView.addArrangedSubview(stateStackView)
        
        view.addSubview(waitingScollView)
        waitingScollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        waitingScollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        waitingScollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        waitingScollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    
        waitingScollView.addSubview(waitingContentStackView)
        waitingContentStackView.topAnchor.constraint(equalTo: waitingScollView.topAnchor).isActive = true
        waitingContentStackView.bottomAnchor.constraint(equalTo: waitingScollView.bottomAnchor).isActive = true
        waitingContentStackView.leadingAnchor.constraint(equalTo: waitingScollView.leadingAnchor).isActive = true
        waitingContentStackView.trailingAnchor.constraint(equalTo: waitingScollView.trailingAnchor).isActive = true
            
        waitingContentStackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width/2).isActive = true
        
        view.addSubview(processingScollView)
        processingScollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        processingScollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        processingScollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        processingScollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    
        processingScollView.addSubview(processingContentStackView)
        processingContentStackView.topAnchor.constraint(equalTo: processingScollView.topAnchor).isActive = true
        processingContentStackView.bottomAnchor.constraint(equalTo: processingScollView.bottomAnchor).isActive = true
        processingContentStackView.leadingAnchor.constraint(equalTo: processingScollView.leadingAnchor).isActive = true
        processingContentStackView.trailingAnchor.constraint(equalTo: processingScollView.trailingAnchor).isActive = true
            
        processingContentStackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width/2).isActive = true
    }
    
    @objc func addTenClients() {
        for _ in 1...10 {
            let addLabel1: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .body)
                label.textColor = .black
                label.isHidden = true
                count += 1
                label.text = "\(count))"
                label.adjustsFontForContentSizeCategory = true
                UIView.animate(withDuration: 0.3) {
                    label.isHidden = false
                }
                return label
            }()
            let addLabel2: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .body)
                label.textColor = .black
                label.isHidden = true
                count += 1
                label.text = "\(count))"
                label.adjustsFontForContentSizeCategory = true
                UIView.animate(withDuration: 0.3) {
                    label.isHidden = false
                }
                return label
            }()
            
            waitingContentStackView.addArrangedSubview(addLabel1)
            processingContentStackView.addArrangedSubview(addLabel2)
        }
  
        print("touchUpInside : addTenClients")
    }
    
    @objc func initQueue() {
        guard let last = waitingContentStackView.arrangedSubviews.last else { return }
        
        UIView.animate(withDuration: 0.3) {
            last.isHidden = true
        } completion: { (_) in
                self.waitingContentStackView.removeArrangedSubview(last)
        }
        print("touchUpInside : initQueue")
    }
}

