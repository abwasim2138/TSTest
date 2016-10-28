//
//  ViewController.swift
//  TSTest
//
//  Created by Abdul-Wasai Wasim on 10/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var takeTestButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var test: Test?
    var currentQuestion = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true

        if let tests = UserSettings.getPastTests() {
            TestDB.singleton.forSavingTests = tests
            for test in tests {
                let timeStamp = test[Constants.timeStampID]
                let results = test[Constants.resultsID]
                let test = Test(timeStamp: timeStamp, questions: nil, results: results)
                if TestDB.singleton.tests == nil {
                    TestDB.singleton.tests = [test]
                }else{
                    TestDB.singleton.tests!.append(test)
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload() {
        self.collectionView.reloadData()
    }
    
    @IBAction func takeTest(_ sender: UIButton) {
        sender.isHidden = true
  
        test = Test()
        test!.questions = [0]
        test!.timeStamp = test!.formattedTimeStamp()
        
        if yesButton.isHidden == true {
          collectionView.isHidden = false
          yesButton.isHidden = false
          noButton.isHidden = false
        }else{
            
        //CHANGE BACK ANIMATION
        yesButton.setTitle("YES", for: .normal)
        noButton.alpha = 1.0
        yesButton.transform = CGAffineTransform(translationX: 0, y: 0)
        noButton.transform = CGAffineTransform(translationX: 0, y: 0)
        
        //BACK TO FIRST QUESTION
        currentQuestion = 0
        let indexPath = IndexPath(row: currentQuestion, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    @IBAction func chooseAnswer(_ sender: UIButton) {
        
        //THE SENDER TAG WILL SEND EITHER A 1 (YES), OR 0 (NO)
        if test!.questions!.count > currentQuestion {
            test!.questions![currentQuestion] = sender.tag
        }else{
            test!.questions!.append(sender.tag)
        }
 
        self.animateChoice(choice: sender)
        self.nextQuestion()
        
    }
    
    private func checkColor(button: UIButton) {
        if button.currentTitleColor == .darkGray {
            button.setTitleColor(.gray, for: .normal)
        }
    }
    
    private func animateChoice (choice: UIButton) {
        
        checkColor(button: yesButton)
        checkColor(button: noButton)
        choice.setTitleColor(.darkGray, for: .normal)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            let scaleAnime = CGAffineTransform(scaleX: 1.5, y: 1.5)
            choice.transform = scaleAnime
            }, completion: {finished in
                let scaleBack = CGAffineTransform(scaleX: 1.0, y: 1.0)
                choice.transform = scaleBack
                
                guard self.test!.questions!.count != 4 else {
                    return self.animateResults()
                }
                choice.setTitleColor(.gray, for: .normal)
                
        })
        
    }
    
    private func nextQuestion () {
        guard currentQuestion != Constants.questions.count-1 else {return}
        
        currentQuestion += 1
        let indexPath = IndexPath(row: currentQuestion, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if currentQuestion == 0 {
            currentQuestion = collectionView.visibleCells.count-1
        }
        
    }
    
    private func animateResults () {
        self.test?.results = self.test!.calculateResults()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { 
            
               self.checkColor(button: self.yesButton)
               self.checkColor(button: self.noButton)
               self.yesButton.transform = CGAffineTransform(translationX: 50, y: 0)
               self.noButton.transform = CGAffineTransform(translationX: -50, y: 0)
            }, completion: {finished in
               self.noButton.alpha = 0.0
               self.yesButton.setTitle(self.test!.results, for: .normal)
                
                if TestDB.singleton.tests == nil {
                    TestDB.singleton.tests = [self.test!]
                }else{
                    TestDB.singleton.tests!.insert(self.test!, at: 0)
                }
                
               //SAVE 
                if TestDB.singleton.forSavingTests != nil {
                    TestDB.singleton.forSavingTests!.insert(self.test!.makeDictionaryForSaving(), at: 0)
                }else{
                  TestDB.singleton.forSavingTests = [self.test!.makeDictionaryForSaving()]
                }
                UserSettings.saveTests(TestDB.singleton.forSavingTests!)
               //
                
               self.takeTestButton.isHidden = false
               self.tableView.reloadData()
        
        })
    }

}
//MARK: - COLLECTION_VIEW

//COLLECTION VIEW IS USED TO ASK QUESTIONS
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionID, for: indexPath) as! QuestionCollectionViewCell
        cell.questionLabel.frame = CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height)
        cell.questionLabel.text = Constants.questions[indexPath.row]
        
        return cell
    }
    
    
}

//MARK: - TABLEVIEW

//AFTER TEST OBJECTS ARE ADDED TO THE TESTDB ARRAY, THEY ARE PRESENTED IN A TABLEVIEW
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestDB.singleton.tests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableID, for: indexPath)
        
        let test = TestDB.singleton.tests![indexPath.row]
        cell.textLabel?.text = test.formattedTimeStamp()
        cell.detailTextLabel?.text = test.results
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            TestDB.singleton.tests!.remove(at: indexPath.row)
            TestDB.singleton.forSavingTests!.remove(at: indexPath.row)
            UserSettings.saveTests(TestDB.singleton.forSavingTests!)
            self.tableView.reloadData()
        }
        
    }
    
    
}






