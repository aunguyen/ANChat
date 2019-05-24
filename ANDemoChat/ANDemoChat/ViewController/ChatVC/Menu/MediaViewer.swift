//
//  MediaViewer.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/23/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import SDWebImage

class MediaViewer: UIViewController,UIScrollViewDelegate {

	@IBOutlet weak private var scrollView: UIScrollView!
	@IBOutlet weak private var imageView:UIImageView!
	var url: URL?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "PhotoViewer"
		//setup scrollview
		self.scrollView.delegate = self
		let minScale = scrollView.frame.size.width / imageView.frame.size.width;
		scrollView.minimumZoomScale = minScale;
		scrollView.maximumZoomScale = 3.0;
		scrollView.contentSize = imageView.frame.size;
		Utilities.showLoading()
		
		//load image
		self.imageView.sd_setImage(with: url) { (image, erro, cache, url) in
			Utilities.hideLoading()
			if let img = image {
				self.imageView.image = img
			}else{
				Utilities.showAlert(title: Constants.ErrorText, msg: erro?.localizedDescription ?? "")
			}
		}
    }

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
