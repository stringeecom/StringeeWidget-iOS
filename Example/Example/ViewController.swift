//
//  ViewController.swift
//  ExampleStringeeWidget
//
//  Created by macos on 3/7/24.
//

import UIKit
import StringeeWidget
import Stringee

let token =
"eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTSy4wLmtYd2x0cGRLVldxejl3eElBV1hiSHVWazVSTXZkbFVWLTE3MjI5MTY5NjUiLCJpc3MiOiJTSy4wLmtYd2x0cGRLVldxejl3eElBV1hiSHVWazVSTXZkbFVWIiwiZXhwIjoxNzI1NTA4OTY1LCJ1c2VySWQiOiJ1c2VySWQxIn0.B5GQ4aMQ68pERiDn1vzUmof6uGzwXZsdXrguqCQt1pk"

class ViewController: UIViewController {

    @IBOutlet weak var lbUserId: UILabel!
    @IBOutlet weak var tfCalleeId: UITextField!
    @IBOutlet weak var sIsVideoCall: UISwitch!
    @IBOutlet weak var btCall: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        StringeeWidget.instance.delegate = self
        StringeeWidget.instance.connect(token: token)
        // StringeeWidget.instance.voipRegistration()

        lbUserId.text = "Connecting..."

        StringeeWidget.instance.applyUIConfig(StringeeCallUIConfig(statsPosition: .center))
    }

    @IBAction func call(_ sender: Any) {
        guard let callee = tfCalleeId.text, !callee.isEmpty else {
            return
        }
        let config = StringeeCallConfig()
        // from current userId
        config.from = "abcdef"
        config.to = callee
        config.isVideoCall = sIsVideoCall.isOn
        config.resolution = .full_hd
        StringeeWidget.instance.makeCall(config: config) { status, code, message, data in
            print(status)
            print(code)
            print(message)
            print(data ?? "")
        }
    }
}

extension ViewController: StringeeWidgetDelegate {
    func onConnectionConnected(userId: String, isReconnecting: Bool) {
        print("\(#function) \(userId) isReconnecting \(isReconnecting)")
        self.lbUserId.text = "Connected as \(userId)"
    }

    func onConnectionDisconnected(isReconnecting: Bool) {
        print("\(#function) isReconnecting \(isReconnecting)")
        self.lbUserId.text = "Disconnected"
    }

    func onConnectionError(code: Int, message: String) {
        print("\(#function) \(code) \(message)")
        self.lbUserId.text = "Connect error with code: \(code) - \(message)"
    }

    func onRequestNewToken() {
        print(#function)
    }

    func onDisplayCallingViewController(vc: UIViewController) {
        print("\(#function) \(vc)")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    func onSignalingState(state: SignalingState) {
        print("\(#function) \(state)")
        switch state {
            case .busy, .ended:
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }

            default:
                // do nothing
                break
        }
    }
}
