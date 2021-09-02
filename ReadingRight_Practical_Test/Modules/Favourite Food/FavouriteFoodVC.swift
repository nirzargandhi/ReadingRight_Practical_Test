//
//  FavouriteFoodVC.swift
//  ReadingRight_Practical_Test
//
//  Created by Nirzar Gandhi on 01/09/21.
//

class FavouriteFoodVC: UIViewController {
    
    //MARK: - UILabel Outlet
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - UICollectionView Outlet
    @IBOutlet weak var cvFoodList: UICollectionView!
    
    //MARK: - Variable Declaration
    var arrMealsList = [Meals]()
    var arrMealID = [String]()
    
    //MARK: - ViewCOntroller Methods
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initialization()
        
        wsFavouriteFoodList()
    }
    
    //MARK: - Initialization Method
    func initialization() {
        
        setNavigationHeader(strTitleName: "Favourite Food")
        
        arrMealID = [String]()
        
        if let mealID : String = KeychainWrapper.standard.string(forKey: UserDefault.kMealID) {
            let arrTempMealID = mealID.split(separator: "-")
            
            for i in 0..<arrTempMealID.count {
                arrMealID.append(String(arrTempMealID[i]))
            }
        }
    }
    
    //MARK: - UIButton Action Method
    @objc func btnFavAction(_ btn: UIButton) {
        
        
        if arrMealID.contains(arrMealsList[btn.tag].idMeal ?? "") {
            let index = arrMealID.indices(where: {$0 == arrMealsList[btn.tag].idMeal ?? ""})
            arrMealID.remove(at: index?[0] ?? 0)
        } else {
            arrMealID.append(arrMealsList[btn.tag].idMeal ?? "")
        }
        
        cvFoodList.reloadData()
        
        let arrTempMealID = arrMealID.joined(separator:"-")
        KeychainWrapper.standard.set("\(arrTempMealID)", forKey: UserDefault.kMealID)
        
        setUserDefault(true, key: UserDefault.kIsKeyChain)
        
        wsFavouriteFoodList()
    }
    
    //MARK: - Webservice Call Method
    func wsFavouriteFoodList() {
        
        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            self.view.makeToast(AlertMessage.msgNetworkConnection)
            return
        }
        
        ApiCall().get(apiUrl: WebServiceURL.MealListURL, model: FoodMenuModal.self, isAPIToken: false) { (success, responseData) in
            if success, let responseData = responseData as? FoodMenuModal {
                let arrTempMealsList = responseData.meals ?? []
                
                self.arrMealsList = [Meals]()
                
                for i in 0..<arrTempMealsList.count {
                    
                    if self.arrMealID.contains(arrTempMealsList[i].idMeal ?? "") {
                        self.arrMealsList.append(arrTempMealsList[i])
                    }
                }
                
                if self.arrMealsList.count > 0 {
                    self.cvFoodList.reloadData()
                    
                    self.cvFoodList.isHidden = false
                    self.lblNoData.isHidden = true
                } else {
                    self.cvFoodList.isHidden = true
                    self.lblNoData.isHidden = false
                }
            } else {
                mainThread {
                    self.view.makeToast(AlertMessage.msgError)
                    
                    self.cvFoodList.isHidden = true
                    self.lblNoData.isHidden = false
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource Extension
extension FavouriteFoodVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMealsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.kCellFavouriteFood, for: indexPath) as! FavouriteFoodCVC
        
        cell.imgvFoodItem.sd_setImage(with: URL(string: arrMealsList[indexPath.row].strMealThumb ?? ""), completed: nil)
        
        if arrMealID.contains(arrMealsList[indexPath.row].idMeal ?? "") {
            cell.btnFav.isSelected = true
            cell.btnFav.tintColor = .appRed()
        } else {
            cell.btnFav.isSelected = false
            cell.btnFav.tintColor = .appRed()
        }
        
        cell.lblFoodName.text = arrMealsList[indexPath.row].strMeal ?? ""
        
        cell.lblFoodCategory.text = arrMealsList[indexPath.row].strCategory ?? ""
        
        cell.btnFav.tag = indexPath.row
        cell.btnFav.addTarget(self, action: #selector(btnFavAction(_:)) , for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objFoodDetailVC = AllStoryBoard.Main.instantiateViewController(withIdentifier: ViewControllerName.kFoodDetailVC) as! FoodDetailVC
        objFoodDetailVC.strMealID = arrMealsList[indexPath.row].idMeal ?? ""
        self.navigationController?.pushViewController(objFoodDetailVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.width/2.0 - 10, height: 235)
        return size
    }
}

