//
//  StatusTableViewController.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 14/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import Firebase
import ARSLineProgress
import AVKit
import AVFoundation

class StatusTableViewController: UITableViewController, FalconUsersUpdatesDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    let myStatusCellID = "myStatusCellID"
    
    let falconUsersFetcher = FalconUsersFetcher()
    
    var users = [User]()
    
    var usersWithStatusUpdates = [User]()
    
    let storageReference = Storage.storage().reference()
    
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if usersWithStatusUpdates.count > 0{
            return 2
        }
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return self.usersWithStatusUpdates.count
        }
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return ""
        }else{
            return "Updates from Contacts"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myStatusCellID, for: indexPath) as? MyStatusTableViewCell
            else{
                return UITableViewCell()
        }
        
        if indexPath.section == 0{
            if let currentUserUID = Auth.auth().currentUser?.uid{
                let userReference = Database.database().reference().child("users").child(currentUserUID)
                userReference.observeSingleEvent(of: .value) { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let name = value?["name"] as? String ?? ""
             
                    cell.myStatusLabel.text = name
                }

            }
        }
        
        if indexPath.section == 1{
            
            
            
            cell.addStatusImageView.isHidden = true
            cell.myStatusLabel.text = self.usersWithStatusUpdates[indexPath.row].name!
            cell.addStatusLabel.text = self.createDateTime(timestamp: <#T##String#>)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            self.displayActionSheetForUploadingStatus()
        }
        
        if indexPath.section == 1 {
            
            if self.usersWithStatusUpdates[indexPath.row].statusMediaType == "image"{
                    let statusImageDisplayViewController = StatusImageDisplayViewControler()
                    guard let imageReferenceURL = self.usersWithStatusUpdates[indexPath.row].statusURL else{return}
                    statusImageDisplayViewController.imageReference = imageReferenceURL
                    
                    self.present(statusImageDisplayViewController, animated: true, completion: nil)
            }else{
                    if let videoURL = self.usersWithStatusUpdates[indexPath.row].statusURL{
                        self.playStatusVideo(videoURLString: videoURL)
                    }
            }
        }
    }
    
    func reloadTableView(updatedUsers: [User]){
        
        self.users = updatedUsers
        self.users = falconUsersFetcher.rearrangeUsers(users: self.users)
        
        usersWithStatusUpdates = self.users.filter{$0.statusURL != nil}
        
        print("USERS ARE",self.users)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    func falconUsers(shouldBeUpdatedTo users: [User]) {
        
        self.reloadTableView(updatedUsers: users)
        
    }
    
    
    func displayActionSheetForUploadingStatus(){
        
        let mediaTypeActionSheet = UIAlertController(title: "Add Status", message: "Choose media type to upload", preferredStyle: .actionSheet)
        
        mediaTypeActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.authorisationStatus(attachmentTypeEnum: .camera)
        }))
        
        mediaTypeActionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary)
        }))
        
        mediaTypeActionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { (action) in
            self.authorisationStatus(attachmentTypeEnum: .video)
        }))
        
        mediaTypeActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(mediaTypeActionSheet, animated: true, completion: nil)
        
    }
    
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType){
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                }
            })
        case .restricted:
            print("permission restricted")
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.originalImage] as? UIImage {
            uploadImage(image: image) {
                ARSLineProgress.showSuccess()
                picker.dismiss(animated: true, completion: nil)
            }
        } else{
            print("Image Not Selected or Some error in image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            print("videourl: ", videoUrl)
            
            do {
                let data = try Data(contentsOf: videoUrl)
                uploadVideo(data: data) {
                    ARSLineProgress.showSuccess()
                    picker.dismiss(animated: true, completion: nil)
                }
            } catch{
                print(error)
            }
        }
        else{
            print("Video not picked or some error in video")
        }
        
    }
    
    func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
            
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
    
    
    func uploadImage(image:UIImage, completion: @escaping ()-> Void){
        
        
        let imageName:String = String("\(Date().timeIntervalSince1970).jpg")
        
        let statusImageReference = storageReference.child("statusMedia").child(imageName)
        
        
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
        
        
        let uploadTask = statusImageReference.putData(uploadData, metadata: nil)
        
        uploadTask.observe(.progress) { (snapshot) in
            
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            ARSLineProgress.showWithProgress(initialValue: CGFloat(percentComplete))
            
        }
        
        uploadTask.observe(.success) { (snapshot) in
            snapshot.reference.downloadURL { (url, error) in
                
                if let error = error{
                    print(error)
                    return
                }
                guard let downloadURL = url, let uid = Auth.auth().currentUser?.uid else {return}
                
                let userReference = Database.database().reference().child("users").child(uid)
                
                let statusTimeStamp = Date().timeIntervalSince1970
                
                let updateValues = ["status" : downloadURL.absoluteString, "statusMediaType":"image","statusTimeStamp":String(statusTimeStamp)]
                
                
                
                userReference.updateChildValues(updateValues) { (error, reference) in
                    if let error = error{
                        print(error)
                        return
                    }
                    completion()
                }
                
                
            }
        }
        
    }
    
    
    func uploadVideo(data:Data, completion: @escaping () -> Void){
        
        
        let videoName:String = String("\(Date().timeIntervalSince1970).mp4")
        
        let statusVideoReference = storageReference.child("statusMedia").child(videoName)
        
        let uploadTask = statusVideoReference.putData(data, metadata: nil)
        
        uploadTask.observe(.progress) { (snapshot) in
            
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            ARSLineProgress.showWithProgress(initialValue: CGFloat(percentComplete))
            
        }
        
        uploadTask.observe(.success) { (snapshot) in
            snapshot.reference.downloadURL { (url, error) in
                
                if let error = error{
                    print(error)
                    return
                }
                guard let downloadURL = url, let uid = Auth.auth().currentUser?.uid else {return}
                
                let userReference = Database.database().reference().child("users").child(uid)
                
                   let statusTimeStamp = Date().timeIntervalSince1970
                
                let updateValues = ["status" : downloadURL.absoluteString, "statusMediaType":"video","statusTimeStamp":String(statusTimeStamp)]
                
                userReference.updateChildValues(updateValues) { (error, reference) in
                    if let error = error{
                        print(error)
                        return
                    }
                    completion()
                }
            }
        }
    }
    
    
    func playStatusVideo(videoURLString:String){
        
        guard let videoURL = URL(string: videoURLString) else {return}
        let statusVideoPlayerViewController = StatusVideoPlayerViewController()
        
        statusVideoPlayerViewController.videoURL = videoURL
        
        self.present(statusVideoPlayerViewController, animated: true) {
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyStatusTableViewCell.self, forCellReuseIdentifier: myStatusCellID)
        
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        
        falconUsersFetcher.delegate = self
        
        DispatchQueue.global(qos: .default).async { [unowned self] in
            self.falconUsersFetcher.fetchFalconUsers(asynchronously: true)
        }
    }
    
    
    
    
    
    
    
}
