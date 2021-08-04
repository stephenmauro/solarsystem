import SceneKit

class Utilities {
    static func createSpinAnimation(ofPeriod period: CFTimeInterval) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = period
        animation.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float.pi * 2))
        animation.repeatCount = Float.infinity
        return animation
    }
    
    static func createOrbitalPath(forDistance orbit: Float, withObjectRadius radius: CGFloat) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(orbit * 2) + radius, height: CGFloat(orbit * 2) + radius)
        plane.firstMaterial?.diffuse.contents = "orbit"
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.mipFilter = .linear
        plane.firstMaterial?.lightingModel = .constant
        let path = SCNNode(geometry: plane)
        path.rotation = SCNVector4(x: 1, y: 0, z:0, w: -Float.pi/2.0)
        return path
    }
    
    static func createOrbitalAnimation(ofPeriod period: CFTimeInterval) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = period
        animation.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float.pi * 2))
        animation.repeatCount = Float.infinity
        return animation
    }
}

public class Ring {
    var node: SCNNode
    var topMaterial: SCNMaterial
    var bottomMaterial: SCNMaterial
    var innerMaterial: SCNMaterial
    var outerMaterial: SCNMaterial
    var geometry: SCNTube

    public init(withInnerRadiusAt innerRadius: CGFloat, andOuterRadiusAt outerRadius: CGFloat, usingImge image: String?) {
        geometry = SCNTube(innerRadius: innerRadius, outerRadius: outerRadius, height: 0.1)
        geometry.radialSegmentCount = 17
        geometry.heightSegmentCount = 3
        topMaterial = SCNMaterial()
        topMaterial.diffuse.contents = image ?? UIColor.white
        topMaterial.diffuse.mipFilter = .linear
        topMaterial.diffuse.contentsTransform = SCNMatrix4MakeRotation(Float.pi / 4.0, 0, 0, 1)
        bottomMaterial = SCNMaterial()
        bottomMaterial.diffuse.contents = image ?? UIColor.white
        innerMaterial = SCNMaterial()
        innerMaterial.diffuse.contents = UIColor.white
        outerMaterial = SCNMaterial()
        outerMaterial.diffuse.contents = UIColor.white
//        geometry.materials = [innerMaterial, outerMaterial, topMaterial, bottomMaterial]
        geometry.firstMaterial = topMaterial
        node = SCNNode(geometry: geometry)
    }
}

public class Moon {
    var node: SCNNode
    var axis: SCNNode
    var collar: SCNNode
    var year: CFTimeInterval
    var material: SCNMaterial
    var geometry: SCNSphere
    
    public init(ofRadius radius: CGFloat,
                atDistance orbit: Float,
                usingImage image: String?,
                orColor color: UIColor?,
                orbitalTime year: CFTimeInterval) {
        self.year = year
        geometry = SCNSphere(radius: radius)
        geometry.segmentCount = 17
        material = SCNMaterial()
        material.diffuse.contents = color ?? image ?? UIColor.white
        node = SCNNode(geometry: geometry)
        geometry.firstMaterial = material
        axis = SCNNode()
        axis.position = SCNVector3(x: orbit, y: 0, z: 0)
        axis.addChildNode(node)
        collar = SCNNode()
        collar.addChildNode(axis)
        
        collar.addChildNode(Utilities.createOrbitalPath(forDistance: orbit, withObjectRadius: radius))
    }
}

public class Planet {
    var node: SCNNode
    var axis: SCNNode
    var collar: SCNNode
    var name: String
    var year: CFTimeInterval
    var material: SCNMaterial
    var geometry: SCNSphere
    
    public init(withName name: String,
                ofRadius radius: CGFloat,
                atDistance orbit: Float,
                usingImage image: String?,
                orColor color: UIColor?,
                withDay period: CFTimeInterval,
                orbitalTime year: CFTimeInterval) {
        self.name = name
        self.year = year
        geometry = SCNSphere(radius: radius)
        geometry.segmentCount = 17
        material = SCNMaterial()
        material.diffuse.contents = color ?? image ?? UIColor.white
        node = SCNNode(geometry: geometry)
        geometry.firstMaterial = material
        axis = SCNNode()
        axis.position = SCNVector3(x: orbit, y: 0, z: 0)
        axis.addChildNode(node)
        collar = SCNNode()
        collar.addChildNode(axis)
        
        if color == nil {
            let spinAnimation = Utilities.createSpinAnimation(ofPeriod: period)
            node.addAnimation(spinAnimation, forKey: name + " spin")
        }
        
        collar.addChildNode(Utilities.createOrbitalPath(forDistance: orbit, withObjectRadius: radius))
    }
    
    public func addMoon(moon: Moon) {
        let collar = moon.collar
        let year = moon.year
        
        axis.addChildNode(collar)
        let orbitalAnimation = Utilities.createOrbitalAnimation(ofPeriod: year)
        collar.addAnimation(orbitalAnimation, forKey: "moon orbit")
    }
    
    public func addRing(ring: Ring) {
        axis.addChildNode(ring.node)
    }
}

public class System {
    public var axis: SCNNode
    var material: SCNMaterial
    var geometry: SCNSphere
    var node: SCNNode
    
    public init() {
        geometry = SCNSphere(radius: 6)
        geometry.segmentCount = 17
        material = SCNMaterial()
        material.diffuse.contents = "sun.jpg"
        geometry.firstMaterial = material
        node = SCNNode(geometry: geometry)
        axis = SCNNode()
        axis.addChildNode(node)
        
        let spinAnimation = Utilities.createSpinAnimation(ofPeriod: 60)
        node.addAnimation(spinAnimation, forKey: "sun spin")
    }
    
    public func addPlanet(planet: Planet) {
        let collar = planet.collar
        let year = planet.year
        let name = planet.name
        
        axis.addChildNode(collar)
        let orbitalAnimation = Utilities.createOrbitalAnimation(ofPeriod: year)
        collar.addAnimation(orbitalAnimation, forKey: name + " orbit")
    }
}
