//
//  OnBoarding.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 30/05/22.
//

import UIKit

class OnBoarding: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    let slides = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",]
    var currentPage = 0 {
        
        didSet{
            pageControl.currentPage = currentPage
            
            if currentPage == slides.count - 1
            {
                nextButton.setTitle("Get Started", for: .normal)
            
            } else {
                
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if currentPage == slides.count - 1
        {
            
            UserDefaults.standard.set(true, forKey: "session")
            let controller = storyboard?.instantiateInitialViewController()!
            controller!.modalPresentationStyle = .overFullScreen
            controller!.modalTransitionStyle = .flipHorizontal
            present(controller!, animated: true)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }
    }
}

extension OnBoarding : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collcell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.imgSlide.image = UIImage(named: slides[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
