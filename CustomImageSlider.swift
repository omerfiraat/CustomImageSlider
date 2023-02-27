import UIKit
import SnapKit

class ImageSliderViewController: UIViewController {
    let cellIdentifier = "ImageCell"
    let images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")]
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.translatesAutoresizingMaskIntoConstraints = false

        return pc
    }()
    var slideTimer: Timer?
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(ImageSliderCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        pageControl.layer.cornerRadius = 8
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(150)
            
        }
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    func startTimer() {
        slideTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(moveToNextSlide), userInfo: nil, repeats: true)
    }
    @objc func moveToNextSlide() {
        let currentIndex = pageControl.currentPage
        let nextIndex = currentIndex + 1
        
        if nextIndex >= images.count {
            pageControl.currentPage = 0
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            pageControl.currentPage = nextIndex
            collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        slideTimer?.invalidate()
        slideTimer = nil
    }
    
    
    
}

//MARK: Extensions

extension ImageSliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageSliderCell
        cell.image = images[indexPath.item]
        return cell
    }
}



extension ImageSliderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
extension ImageSliderViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        pageControl.currentPage = currentPage
    }
}


//MARK: Cell Class

class ImageSliderCell: UICollectionViewCell {
    lazy var imageView: UIImageView = UIImageView()
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    
    
    override init(frame: CGRect) {
        
        super .init(frame: .zero)
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "image1")
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init: (coder:) has been not implemented")
    }
}
