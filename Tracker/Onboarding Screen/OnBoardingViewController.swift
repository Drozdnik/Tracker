import UIKit

class OnBoardingViewController: UIPageViewController{
    private lazy var pages: [UIViewController] = {
        return []
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendPages()
        setupViews()
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
        delegate = self
    }
    
    
    private func appendPages() {
        let page1 = OnboardingPageEnum.page1
        let page1ViewController = OnboardingPage(image: page1.image, messageLabel: page1.message)
        
        let page2 = OnboardingPageEnum.page2
        let page2ViewController = OnboardingPage(image: page2.image, messageLabel: page2.message)
        
        pages.append(contentsOf: [page1ViewController, page2ViewController])
        
        pageControl.numberOfPages = pages.count
    }

    
    private func setupViews(){
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 60),
            actionButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    @objc private func actionButtonTapped() {
        UserDefaults.standard.set(true, forKey: "HasViewedOnboarding")
        self.dismiss(animated: true)
    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return pages.last
        } else {
            return pages[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        if nextIndex >= pages.count {
            return pages.first
        } else {
            return pages[nextIndex]
        }
    }
}

extension OnBoardingViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
                pageControl.currentPage = index
            }
        }
}
