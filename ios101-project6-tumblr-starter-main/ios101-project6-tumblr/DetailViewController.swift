//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Sadia on 31/03/2024.
//

import UIKit
import Nuke

class DetailViewController: UIViewController 
{
    var post: Post!
    var testText: String!
    @IBOutlet weak var detailView: UITextView!
    

    @IBOutlet weak var imageView: UIImageView!
 
 
    override func viewDidLoad()
    {
        
      
        super.viewDidLoad()
        title = testText
     
        detailView.text = post.caption.trimHTMLTags();
        if let photo = post.photos.first
        {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: imageView)
        }
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = true
        detailView.layer.cornerRadius = 10;
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
