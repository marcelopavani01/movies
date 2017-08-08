//
//  MovieDetailViewController.swift
//  testeDafiti
//
//  Created by Marcelo Roberto Pavani on 07/08/17.
//  Copyright © 2017 Marcelo Pavani. All rights reserved.
//

import UIKit
import Social

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var label_Title: UILabel!
    @IBOutlet weak var label_genres: UILabel!
    @IBOutlet weak var label_rating: UILabel!
    @IBOutlet weak var label_sinopse: UITextView!

    var trakt = Trakt()
    var movies = [Movie]()
    var fanart = Fanart()
    var activity = customActivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((movies))
        
        self.title = self.movies[0].title
        
        activity.customActivityIndicatory(self.view, startAnimate: true)
        self.loadData()
        activity.customActivityIndicatory(self.view, startAnimate: false)

    }
    
    func loadData() {
    
        self.label_Title.text = movies[0].title
        self.label_genres.text = movies[0].genres?.joined(separator: " , ")
        
        if let ratingSelected = movies[0].rating {
            self.label_rating.text = "\(String(format:"%.01f", ratingSelected))"
        }

        self.label_sinopse.text = movies[0].summary
        
        activity.customActivityIndicatory(self.view, startAnimate: true)
        fanart.requestThumbUrl(for: movies[0], completion: { (bannerUrl) in
            
            self.imgMovie.af_setImage(withURL: bannerUrl, placeholderImage: UIImage(named:"placeHolder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: nil)
            self.activity.customActivityIndicatory(self.view, startAnimate: false)
        })
    }
    
    @IBAction func sharing(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sharing", message: "Choose the Social Media", preferredStyle: .actionSheet)
        
        let FaceAction = UIAlertAction(title: "Facebook", style: .default, handler: goFace)
        let TwitterAction = UIAlertAction(title: "twitter", style: .default, handler: goTwitter)
        let CancelAction = UIAlertAction(title: "Cancel", style: .default, handler: cancel)
        
        alert.addAction(FaceAction)
        alert.addAction(TwitterAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect  = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func goFace(alertAction: UIAlertAction!) -> Void {
            
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

            fbShare.title = self.label_Title.text
            fbShare.setInitialText(self.label_Title.text)
            fbShare.add(self.imgMovie.image)

            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goTwitter(alertAction: UIAlertAction!) -> Void {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            tweetShare.setInitialText(self.label_Title.text)
            tweetShare.add(self.imgMovie.image)
            
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func cancel(alertAction: UIAlertAction!) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
