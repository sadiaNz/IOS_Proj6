//
//  ViewController.swift
//  ios101-project6-tumblr
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []
    var indexRowPost : Int = 0;
    override func viewDidLoad()
    {
        //title = "Blog Posts";
        super.viewDidLoad()
        self.title = "Blog Posts"
       
        navigationItem.backButtonTitle = "Blog Posts"
        tableView.allowsSelection = true
        tableView.dataSource = self
        fetchPosts()
   

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("something, \(indexPath.row)" )
        indexRowPost = indexPath.row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.25
         )
        let post = posts[indexPath.row]
        cell.summaryLabel.text = post.summary
       
        cell.postImageView.layer.cornerRadius = 10;
        cell.postImageView.clipsToBounds = true
        if let photo = post.photos.first
        {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postImageView)
        }

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
    {
            let destinationVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
           // Get the Row of the Index Path and set as index
            let index = indexPath?.row
            destinationVC.testText =  "Post detail";//posts [index].caption
            destinationVC.post = posts [index!]
    
           
    }
    func fetchPosts() 
    {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
             //   print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                //print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts
                    self?.posts = posts
                    self?.tableView.reloadData()

//                    print("✅ We got \(posts.count) posts!")
//                    for post in posts {
//                        print("🍏 Summary: \(post.summary)")
//                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}

