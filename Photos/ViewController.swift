import UIKit
import Kingfisher

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var mainScreen: UIImageView!
    @IBOutlet weak var blueEffect: UIVisualEffectView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var likeButtonn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var delete: UIButton!
    
    
    // MARK: - Global var, let
    
    let imagePicker = UIImagePickerController()
    var imageName = ""
    let customImages = CustomImage()
    var imagesArray: [CustomImage] = []
    
    var index = 0
    
    var secondImageView = UIImageView()
    var thirdImageView = UIImageView()
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadImages), name: NSNotification.Name(rawValue: "update"), object: nil)
        
        self.likeButtonn.setShadow()
        self.textField.setShadow()
        self.likeLabel.setShadow()
//        self.tap()
        self.tapImage()
        self.imagesArray = Manager.shared.loadArray()
        
        self.leftRecognizer()
        self.rightRecognizer()
        
        self.imagesView(firstImageView)
        self.imagesView(secondImageView)
        self.imagesView(thirdImageView)
        
        self.loadImages()
//        self.likeButtonn.isSelected = Manager.shared.loadArray()[index].like
//        self.textField.text = Manager.shared.loadArray()[index].comment
        
        self.imagePicker.delegate = self
        DispatchQueue.main.async {
            self.passwordEnterAlert(password: "123")
            
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.deleteAlert()
    }
    
    
    @IBAction func showMoreActions(touch: UITapGestureRecognizer) {
        self.view.endEditing(true)
        imagesArray[index].comment = textField.text
        Manager.shared.update(items: imagesArray)
    }
    
    @IBAction func showMoreActionsTwo(touch: UITapGestureRecognizer) {
        
        if self.likeButtonn.isSelected == true {
            self.likeButtonn.isSelected = false
        } else {
            self.likeButtonn.isSelected = true
        }
        if !Manager.shared.loadArray().isEmpty {
            self.imagesArray[index].like = likeButtonn.isSelected
            Manager.shared.update(items: imagesArray)
        }
    }
    
    @objc func loadImages() {
        if !Manager.shared.loadArray().isEmpty {
            self.firstImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
            self.likeButtonn.isSelected = Manager.shared.loadArray()[index].like
            self.textField.text = Manager.shared.loadArray()[index].comment
            
        }
        collectionView.reloadData()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        self.pick()
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !Manager.shared.loadArray().isEmpty {
            imagesArray[index].like = sender.isSelected
            Manager.shared.update(items: imagesArray)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.bottomConstraint.constant = 170
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.bottomConstraint.constant += keyboardScreenEndFrame.height
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - SwipeActions
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if !Manager.shared.loadArray().isEmpty {
            self.move(Direction.left)
            firstImageView.isHidden = false
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if !Manager.shared.loadArray().isEmpty {
            self.move(Direction.right)
            firstImageView.isHidden = false
        }
    }
    
    // MARK: - Functions
    
    func pick() {
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func tap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMoreActions(touch:)))
        view.addGestureRecognizer(tap)
    }
    
    func tapImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMoreActionsTwo(touch:)))
        tap.numberOfTapsRequired = 2
        containerView.addGestureRecognizer(tap)
    }
    
    func imagesView(_ image: UIImageView) {
        
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        imagesArray[index].comment = textField.text
        Manager.shared.update(items: imagesArray)
        print("000")
        return true
    }
    
    
    
    func addRightImageView() {
        self.secondImageView.frame = CGRect(x: self.view.frame.size.width, y: self.firstImageView.frame.origin.y, width: self.firstImageView.frame.size.width, height: self.firstImageView.frame.size.height)
        self.containerView.addSubview(secondImageView)
    }
    
    func addCenterImageView() {
        self.thirdImageView.frame = CGRect(x: self.firstImageView.frame.origin.x, y: self.firstImageView.frame.origin.y, width: self.firstImageView.frame.size.width, height: self.firstImageView.frame.size.height)
        self.containerView.addSubview(thirdImageView)
    }
    
    
    
    func leftRecognizer() {
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLeftRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
    }
    
    
    
    func rightRecognizer() {
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRightRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
    }
    
    func move(_ direction: Direction) {
        switch direction {
        case .left:
            self.addRightImageView()
            
            self.index += 1
            if self.index > Manager.shared.loadArray().count - 1 {
                self.index = 0
            }
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.firstImageView.alpha = 0.0
                self.secondImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
                self.secondImageView.frame.origin.x = self.firstImageView.frame.origin.x
                
            }) { (_) in
                
                self.firstImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
                self.secondImageView.removeFromSuperview()
                self.firstImageView.alpha = 1
            }
            
            
        case .right:
            self.addCenterImageView()
            
            self.thirdImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
            self.index -= 1
            if self.index < 0 {
                self.index = Manager.shared.loadArray().count - 1
            }
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
                self.thirdImageView.alpha = 0.0
                self.firstImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
                self.thirdImageView.frame.origin.x = self.view.frame.size.width
                
            }) { (_) in
                self.thirdImageView.alpha = 1
                self.thirdImageView.removeFromSuperview()
                
            }
            
        }
        
        likeButtonn.isSelected = Manager.shared.loadArray()[index].like
        textField.text = Manager.shared.loadArray()[index].comment
        
        
    }
    
    // MARK: - Enum
    
    enum Direction {
        case left
        case right
    }
}

// MARK: - Extension

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Manager.shared.loadArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.photos.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[indexPath.row].imagePath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        self.firstImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
        
        likeButtonn.isSelected = Manager.shared.loadArray()[index].like
        textField.text = Manager.shared.loadArray()[index].comment
        
    }
}





//            firstImageView.transform = CGAffineTransform(translationX: 100, y: 100)
//            firstImageView.transform = CGAffineTransform(rotationAngle: 360)
//            firstImageView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)

