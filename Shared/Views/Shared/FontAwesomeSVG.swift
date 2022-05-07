//
//  FontAwesomeSVG.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI
import PocketSVG

struct FontAwesomeSVG: UIViewRepresentable {
  let svgName: String
  let frameHeight: CGFloat
  var color: CGColor? = UIColor.white.cgColor
  var color2: CGColor? = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
  var swapColor: Bool? = false
  var actAsSolid: Bool? = false
  
  func makeUIView(context: Context) -> UIView {
    let scale = frameHeight / ICON_HEIGHT_DEFAULT
    let url = Bundle.main.url(forResource: self.svgName, withExtension: "svg")!
    let svgView = UIView()
    svgView.contentMode = .scaleAspectFit
    let paths = SVGBezierPath.pathsFromSVG(at: url)
    let svgLayer = CALayer()
    svgLayer.frame = svgView.bounds
    svgLayer.contentsGravity = .center
    for (index, path) in paths.enumerated() {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path.cgPath
      if(swapColor!){
        shapeLayer.fillColor = (index == 0) ? getColor2() : color
      }else{
        shapeLayer.fillColor = (index == 0) ? color : getColor2()
      }
      svgLayer.addSublayer(shapeLayer)
    }
    
    svgLayer.transform = CATransform3DMakeScale(scale, scale, 1.0)
    svgLayer.position = svgView.center
    svgView.layer.addSublayer(svgLayer)
    return svgView
  }
  
  func getColor2() -> CGColor {
    if (actAsSolid!) {
      return color!
    }
    if(color2!.components == UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor.components && color !=  UIColor.white.cgColor){
      return color!.copy(alpha: 0.5)!
    }
    return color2!
  }
  
  func updateUIView(_ uiView: UIView, context: Context){ }
}
