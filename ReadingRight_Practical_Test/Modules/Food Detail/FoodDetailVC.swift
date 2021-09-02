//
//  FoodDetailVC.swift
//  ReadingRight_Practical_Test
//
//  Created by Nirzar Gandhi on 01/09/21.
//

class FoodDetailVC: UIViewController {
    
    //MARK: - UIScrollView Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - UIImageView Outlet
    @IBOutlet weak var imgvFoodItem: UIImageView!
    
    //MARK: - UILabel Outlets
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var lblIngredient: UILabel!
    @IBOutlet weak var lblMeasurement: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - Variable Declaration
    var strMealID : String?
    
    //MARK: - ViewCOntroller Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        
        wsMealDetail()
    }
    
    //MARK: - Initialization Method
    func initialization() {
        
        setNavigationHeader(strTitleName: "Food Detail", isTabbar: false)
        setupBackButton(isTabbar: false)
    }
    
    //MARK: - Webservice Call Method
    func wsMealDetail() {
        
        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            self.view.makeToast(AlertMessage.msgNetworkConnection)
            return
        }
        
        ApiCall().get(apiUrl: "\(WebServiceURL.MealDetailURL)\(strMealID ?? "")", model: FoodMenuModal.self, isAPIToken: false) { (success, responseData) in
            if success, let responseData = responseData as? FoodMenuModal {
                
                if responseData.meals?.count ?? 0 > 0 {
                    self.setData(dictMealDetail: (responseData.meals?[0])!)
                    
                    self.scrollView.isHidden = false
                    self.lblNoData.isHidden = true
                } else {
                    self.scrollView.isHidden = true
                    self.lblNoData.isHidden = false
                }
            } else {
                mainThread {
                    self.view.makeToast(AlertMessage.msgError)
                    
                    self.scrollView.isHidden = true
                    self.lblNoData.isHidden = false
                }
            }
        }
    }
    
    //MARK: - Set Data Method
    func setData(dictMealDetail : Meals) {
        
        imgvFoodItem.sd_setImage(with: URL(string: dictMealDetail.strMealThumb ?? ""), completed: nil)
        
        lblFoodName.text = dictMealDetail.strMeal ?? "Dish Name - NA"
        
        lblCategory.text = dictMealDetail.strCategory ?? "NA"
        
        lblTag.text = dictMealDetail.strTags ?? "NA"
        
        lblInstructions.text = dictMealDetail.strInstructions ?? "NA"
        
        lblIngredient.text = "\(dictMealDetail.strIngredient1 ?? ""),  \(dictMealDetail.strIngredient2 ?? ""), \(dictMealDetail.strIngredient3 ?? ""), \(dictMealDetail.strIngredient4 ?? ""), \(dictMealDetail.strIngredient5 ?? ""), \(dictMealDetail.strIngredient6 ?? ""), \(dictMealDetail.strIngredient7 ?? ""), \(dictMealDetail.strIngredient8 ?? ""), \(dictMealDetail.strIngredient9 ?? ""), \(dictMealDetail.strIngredient10 ?? ""), \(dictMealDetail.strIngredient11 ?? ""), \(dictMealDetail.strIngredient12 ?? ""), \(dictMealDetail.strIngredient13 ?? ""), \(dictMealDetail.strIngredient14 ?? ""), \(dictMealDetail.strIngredient15 ?? ""), \(dictMealDetail.strIngredient16 ?? ""), \(dictMealDetail.strIngredient17 ?? ""), \(dictMealDetail.strIngredient18 ?? ""), \(dictMealDetail.strIngredient19 ?? ""), \(dictMealDetail.strIngredient20 ?? "")"
        
        lblMeasurement.text = "\(dictMealDetail.strMeasure1 ?? ""),  \(dictMealDetail.strMeasure2 ?? ""), \(dictMealDetail.strMeasure3 ?? ""), \(dictMealDetail.strMeasure4 ?? ""), \(dictMealDetail.strMeasure5 ?? ""), \(dictMealDetail.strMeasure6 ?? ""), \(dictMealDetail.strMeasure7 ?? ""), \(dictMealDetail.strMeasure8 ?? ""), \(dictMealDetail.strMeasure9 ?? ""), \(dictMealDetail.strMeasure10 ?? ""), \(dictMealDetail.strMeasure11 ?? ""), \(dictMealDetail.strMeasure12 ?? ""), \(dictMealDetail.strMeasure13 ?? ""), \(dictMealDetail.strMeasure14 ?? ""), \(dictMealDetail.strMeasure15 ?? ""), \(dictMealDetail.strMeasure16 ?? ""), \(dictMealDetail.strMeasure17 ?? ""), \(dictMealDetail.strMeasure18 ?? ""), \(dictMealDetail.strMeasure19 ?? ""), \(dictMealDetail.strMeasure20 ?? "")"
    }
}
