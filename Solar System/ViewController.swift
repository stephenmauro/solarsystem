//
//  ViewController.swift
//  Solar System
//
//  Created by Stephen Mauro on 8/1/21.
//

import UIKit
import SceneKit
import QuartzCore


class ViewController: UIViewController {

    func setup() {
        let sceneView = self.view as! SCNView
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLight.LightType.omni
        scene.rootNode.addChildNode(lightNode)
        
        let imageNames = ["map-right", "map-left", "map-top", "map-bottom", "map-front", "map-back"]
        let images: [UIImage] = imageNames.map { UIImage(named: $0)! }
        
        scene.background.contents = images
        
        // a camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        let cameraHandle = SCNNode()
        let cameraOrientation = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 8)
        cameraHandle.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraHandle.addChildNode(cameraOrientation)
        cameraOrientation.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraHandle)
        
        let sunAxis = SCNNode()
        
        // a geometry object
        let sun = SCNSphere(radius: 1)
        let sunNode = SCNNode(geometry: sun)
        
        sunAxis.addChildNode(sunNode)
        scene.rootNode.addChildNode(sunAxis)
        
        // configure the geometry object
        
        sunNode.geometry?.firstMaterial?.multiply.contents = UIImage(named: "sun")
        sunNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
        sunNode.geometry?.firstMaterial?.multiply.intensity = 0.5
        sunNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        sunNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        
        // animate the rotation of the sun
        let sunSpin = CABasicAnimation(keyPath: "rotation")
        sunSpin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        sunSpin.duration = 10
        sunSpin.repeatCount = HUGE // for infinity
        sunNode.addAnimation(sunSpin, forKey: "spin around")
        
        let sunMercuryCollar = SCNNode()
        sunAxis.addChildNode(sunMercuryCollar)
        
        let mercuryAxis = SCNNode()
        
        let mercuryRadius = SCNNode()
        mercuryRadius.position = SCNVector3(x: 4, y: 0, z: 0)
        
        let mercuryNode = SCNNode()
        mercuryNode.geometry = SCNSphere(radius: 0.2)
        mercuryNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "mercurymapthumb")
        mercuryNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        mercuryAxis.addChildNode(mercuryNode)
        mercuryRadius.addChildNode(mercuryAxis)
        sunMercuryCollar.addChildNode(mercuryRadius)
        
        let mercuryOrbit = CABasicAnimation(keyPath: "rotation")
        mercuryOrbit.duration = 8.8
        mercuryOrbit.toValue = NSValue(scnVector4:SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        mercuryOrbit.repeatCount = HUGE
        sunMercuryCollar.addAnimation(mercuryOrbit, forKey: "mercury orbit")
        
        let sunVenusCollar = SCNNode()
        sunAxis.addChildNode(sunVenusCollar)
        
        let venusAxis = SCNNode()
        
        let venusRadius = SCNNode()
        venusRadius.position = SCNVector3(x: 6, y: 0, z: 0)
        
        let venusNode = SCNNode()
        venusNode.geometry = SCNSphere(radius: 0.5)
        venusNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "venusmapthumb")
        venusNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        venusAxis.addChildNode(venusNode)
        venusRadius.addChildNode(venusAxis)
        sunVenusCollar.addChildNode(venusRadius)
        
        let venusOrbit = CABasicAnimation(keyPath: "rotation")
        venusOrbit.duration = 8.8
        venusOrbit.toValue = NSValue(scnVector4:SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        venusOrbit.repeatCount = HUGE
        sunVenusCollar.addAnimation(venusOrbit, forKey: "venus orbit")

        let sunEarthCollar = SCNNode()
        sunAxis.addChildNode(sunEarthCollar)
        
        let earthAxis = SCNNode()
        
        let earthRadius = SCNNode()
        earthRadius.position = SCNVector3(x: 8, y: 0, z: 0)
        earthRadius.name = "earth-radius"
        
        let earthNode = SCNNode()
        earthNode.geometry = SCNSphere(radius: 0.5)
        earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        earthNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        earthAxis.addChildNode(earthNode)
        earthRadius.addChildNode(earthAxis)
        sunEarthCollar.addChildNode(earthRadius)
        
        let earthOrbit = CABasicAnimation(keyPath: "rotation")
        earthOrbit.duration = 36.5
        earthOrbit.toValue = NSValue(scnVector4:SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        earthOrbit.repeatCount = HUGE
        sunEarthCollar.addAnimation(earthOrbit, forKey: "earth orbit")
        
        let earthSpin = CABasicAnimation(keyPath: "rotation")
        earthSpin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        earthSpin.duration = 1
        earthSpin.repeatCount = HUGE
        earthNode.addAnimation(earthSpin, forKey: "earth spin")
        
        let earthMoonCollar = SCNNode()
        earthAxis.addChildNode(earthMoonCollar)
        
        let moonRadius = SCNNode()
        moonRadius.position = SCNVector3(x: 1, y: 0, z: 0)
        
        let moonNode = SCNNode()
        moonNode.geometry = SCNSphere(radius: 0.3)
        moonNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "moon")
        moonNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        moonRadius.addChildNode(moonNode)
        earthMoonCollar.addChildNode(moonRadius)
        
        let moonOrbit = CABasicAnimation(keyPath: "rotation")
        moonOrbit.duration = 2.8
        moonOrbit.toValue = NSValue(scnVector4:SCNVector4(x: 0, y: 1, z: 0, w: 2.0 * 3.14))
        moonOrbit.repeatCount = HUGE
        earthMoonCollar.addAnimation(moonOrbit, forKey: "moon orbit")
        
        sceneView.allowsCameraControl = true
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        setup()
    }
    
    override func loadView() {
        self.view = SCNView();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

