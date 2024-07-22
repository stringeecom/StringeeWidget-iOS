//
//  ViewController.swift
//  ExampleStringeeWidget
//
//  Created by macos on 3/7/24.
//

import UIKit
import StringeeWidget
import Stringee

let stringeeToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTSy4wLkFCMmFIeUpVNkVwakEyMHN6MWw2NG1WRklhVzRaQ1YyLTE3MTk5OTA1MDciLCJpc3MiOiJTSy4wLkFCMmFIeUpVNkVwakEyMHN6MWw2NG1WRklhVzRaQ1YyIiwiZXhwIjoxNzIyNTgyNTA3LCJ1c2VySWQiOiJhYmNkZWYifQ.aReF31ln_3jZgVyqfPwd3VAMfrlWS89pInN0MOwR5HE"

let zxcvbnmToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTSy4wLkFCMmFIeUpVNkVwakEyMHN6MWw2NG1WRklhVzRaQ1YyLTE3MjAwNzYxOTIiLCJpc3MiOiJTSy4wLkFCMmFIeUpVNkVwakEyMHN6MWw2NG1WRklhVzRaQ1YyIiwiZXhwIjoxNzIyNjY4MTkyLCJ1c2VySWQiOiJ6eGN2Ym5tIn0.hMs2bpNTV1AyPndvDfPEtaC-OObLDQ2pAfUHHxo2gzs"

let tai1 =
"eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS0UxUmRVdFVhWXhOYVFRNFdyMTVxRjF6VUp1UWRBYVZULTE3MjAwODI3NDQiLCJpc3MiOiJTS0UxUmRVdFVhWXhOYVFRNFdyMTVxRjF6VUp1UWRBYVZUIiwiZXhwIjoxNzIyNjc0NzQ0LCJ1c2VySWQiOiJ0YWkxIn0.rpLrL3-hLbOaNl89jYpes0ziV_BRHbpv_m9Bn7Ki2T8"

class ViewController: UIViewController {

    @IBOutlet weak var lbUserId: UILabel!
    @IBOutlet weak var tfCalleeId: UITextField!
    @IBOutlet weak var sIsVideoCall: UISwitch!
    @IBOutlet weak var btCall: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        StringeeWidget.instance.delegate = self
        StringeeWidget.instance.connect(token: tai1)
        // StringeeWidget.instance.voipRegistration()

        lbUserId.text = "Connecting..."
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
