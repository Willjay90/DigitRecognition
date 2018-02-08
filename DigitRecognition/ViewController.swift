//
//  ViewController.swift
//  HandWritingRecognition
//
//  Created by Wei Chieh Tseng on 05/12/2017.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var recognizeBtn: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    
    var request = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
        
        setupCoreMLRequest()
    }
    
    private func setupCoreMLRequest() {
        // load model
//        let download_model = MNIST().model
        let my_model = my_mnist().model
        
        guard let model = try? VNCoreMLModel(for: my_model) else {
            fatalError("Cannot load Core ML Model")
        }
        
        // set up request
        let MNIST_request = VNCoreMLRequest(model: model, completionHandler: handleMNISTClassification)
        self.request = [MNIST_request]
    }
    
    // handle request
    func handleMNISTClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            debugPrint("No results")
            return
        }
        
        print(observations)
        
        let classification = observations
            .flatMap({ $0 as? VNClassificationObservation  })
            .filter({$0.confidence > 0.8})                      // filter confidence > 80%
            .map({$0.identifier})                               // map the identifier as answer
        
        updateLabel(with: classification.first)
        
    }
    
    private func updateLabel(with text: String?) {
        // update UI should be on main thread
        DispatchQueue.main.async {
            self.answerLabel.text = text
        }
    }
    
    private func setupAutoLayout() {
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        recognizeBtn.translatesAutoresizingMaskIntoConstraints = false
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // answerLabel
            answerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            answerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            answerLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            answerLabel.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 2 - 50),
            
            // canvas
            canvasView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            canvasView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            canvasView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 2),
            
            // clear button
            clearBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clearBtn.bottomAnchor.constraint(equalTo: canvasView.topAnchor),
            clearBtn.widthAnchor.constraint(equalToConstant: 100),
            clearBtn.heightAnchor.constraint(equalToConstant: 50),
            
            // recognize button
            recognizeBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            recognizeBtn.bottomAnchor.constraint(equalTo: canvasView.topAnchor),
            recognizeBtn.widthAnchor.constraint(equalToConstant: 100),
            recognizeBtn.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clearCanvas()
        answerLabel.text = "?"
    }
    
    @IBAction func recognize(_ sender: UIButton) {
        // The model takes input with 28 by 28 pixels, check the uiimage extension for
        // - Get snapshot of an view (Canvas)
        // - Resize image
        
        let image = UIImage(view: canvasView).scale(toSize: CGSize(width: 28, height: 28))
        
        let imageRequest = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try imageRequest.perform(request)
        }
        catch {
            print(error)
        }
    }
    
    
}

