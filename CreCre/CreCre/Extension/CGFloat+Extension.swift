//
//  CGFloat+Extension.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import UIKit

extension CGFloat {
  // MARK: - Spacing
  static let smallSpacing: CGFloat = 8
  static let defaultSpacing: CGFloat = UIDevice.isPad ? 20 : 16
  static let bottomInset: CGFloat = 33

  // MARK: - CornerRadius
  static let smallRadius: CGFloat = 10
  static let defaultRadius: CGFloat = 20

  // MARK: - FontSize
  static let defaultFontSize: CGFloat = UIDevice.isPad ? 23 : 18
}
