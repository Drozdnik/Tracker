import UIKit

class OnBoardingViewController: UIPageViewController{
    lazy var pages: [UIViewController] = {
        return []
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .brown
        pageControl.pageIndicatorTintColor = .orange
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        appendPages()
        setupViews()
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func appendPages(){
        let page1Image = UIImage(named: "Onboarding1")!
        let page2Image = UIImage(named: "Onboarding2")!
        let page1Message = "Отслеживайте только то, что хотите 😍"
        let page2Message = "Даже если это не литры воды и йога 🔥"
        let page1 = OnboardingPage(image: page1Image, messageLabel: page1Message)
        let page2 = OnboardingPage(image: page2Image, messageLabel: page2Message)
        pages.append(contentsOf: [page1, page2])
    }
    
    private func setupViews(){
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func actionButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex > 0 else {
            return nil
        }
        return pages[viewControllerIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex < pages.count - 1 else {
            return nil
        }
        return pages[viewControllerIndex + 1]
    }
}

extension OnBoardingViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
                pageControl.currentPage = index
            }
        }
}
