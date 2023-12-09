//
//  FontAwesomeSVG.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import PocketSVG
import SwiftUI

#if canImport(UIKit)
struct FontAwesomeSVG: UIViewRepresentable {
  let svgName: String
  let frameHeight: CGFloat
  var color: CGColor? = Color.white.cgColor!
  var color2: CGColor? = Color(hex: "#FFFFFF").cgColor!.copy(alpha: 0.5)
  var swapColor = false
  var actAsSolid = false

  func makeUIView(context: Context) -> UIView {
    let svgView = UIView()
    svgView.contentMode = .scaleAspectFit
    var svgLayer = CALayer()
    svgLayer.frame = svgView.bounds

    makeLayer(svgName: svgName,
              frameHeight: frameHeight,
              color: color!,
              color2: color2!,
              swapColor: swapColor,
              actAsSolid: actAsSolid,
              svgLayer: &svgLayer)

    svgLayer.position = svgView.center
    svgView.layer.addSublayer(svgLayer)
    return svgView
  }

  // swiftlint:disable:next opening_brace
  func updateUIView(_ uiView: UIView, context: Context){ }
}
#else
class IconView: NSView {
  override var isFlipped: Bool {
      // swiftlint:disable:next implicit_getter
      get {
          return true
      }
  }
}
struct FontAwesomeSVG: NSViewRepresentable {
  let svgName: String
  let frameHeight: CGFloat
  var color: CGColor? = Color.white.cgColor!
  var color2: CGColor? = Color(hex: "#FFFFFF").cgColor!.copy(alpha: 0.5)
  var swapColor = false
  var actAsSolid = false

  func makeNSView(context: Context) -> IconView {
    let svgView = IconView()
    svgView.layer = CALayer()
    svgView.layer?.contentsGravity = .resizeAspect
    svgView.wantsLayer = true

    var svgLayer = CALayer()
    svgLayer.frame = svgView.bounds

    makeLayer(svgName: svgName,
              frameHeight: frameHeight,
              color: color!,
              color2: color2!,
              swapColor: swapColor,
              actAsSolid: actAsSolid,
              svgLayer: &svgLayer)

    svgView.layer?.addSublayer(svgLayer)
    return svgView
  }

  func updateNSView(_ nsView: NSViewType, context: Context) { }
}
#endif

private func makeLayer(svgName: String,
                       frameHeight: CGFloat,
                       color: CGColor,
                       color2: CGColor,
                       swapColor: Bool,
                       actAsSolid: Bool,
                       svgLayer: inout CALayer) {
  let scale = frameHeight / ICON_HEIGHT_DEFAULT
  let url = Bundle.main.url(forResource: svgName, withExtension: "svg")!
  let paths = SVGBezierPath.pathsFromSVG(at: url)
  svgLayer.contentsGravity = .center
  for (index, path) in paths.enumerated() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    if swapColor {
      shapeLayer.fillColor = (index == 0) ? getColor2(actAsSolid: actAsSolid,
                                                      color: color,
                                                      color2: color2) : color
    } else {
      shapeLayer.fillColor = (index == 0) ? color : getColor2(actAsSolid: actAsSolid,
                                                              color: color,
                                                              color2: color2)
    }
    svgLayer.addSublayer(shapeLayer)
  }

  svgLayer.transform = CATransform3DMakeScale(scale, scale, 1.0)
}

private func getColor2(actAsSolid: Bool, color: CGColor, color2: CGColor) -> CGColor {
  if actAsSolid {
    return color
  }
  if color2.components == Color(hex: "#FFFFFF").cgColor!.copy(alpha: 0.5)?.components && color != Color.white.cgColor {
    return color.copy(alpha: 0.5)!
  }
  return color2
}

private func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}
