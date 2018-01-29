//
//  ViewControllerAcceder.swift
//  Caile
//
//  Created by Nery on 03/01/18.
//  Copyright © 2018 Nery. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewControllerAcceder: UIViewController ,FBSDKLoginButtonDelegate{
    
    //boton para ingresar con facebook
    let loginButtonFb : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    @objc var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var btnIngresar: UIButton!
    
    @IBOutlet weak var textFielCorreo: UITextField!
    @IBOutlet weak var textFieldContrasena: UITextField!
    
    let miAlertDialog = MiAlertDialog()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        creaUI()
        // Do any additional setup after loading the view.
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE] handle que escucha los evento relacionados con el login de los usuarios
            print("handle")
            if user != nil{
                //Intancia el storyboard
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                //Instancia del view controler correspondiente al tabBarController
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarViewController")
                //Intacia de uiAplication
                let uiApp = UIApplication.shared.delegate as! AppDelegate
                uiApp.window?.rootViewController = tabBarController
            }
            /*
             if let user = user {
             // The user's ID, unique to the Firebase project.
             // Do NOT use this value to authenticate with your backend server,
             // if you have one. Use getTokenWithCompletion:completion: instead.
             // let uid = user.uid
             // let email = user.email
             // let photoURL = user.photoURL
             //print("uduario uid: \(uid) email: \(email) photo: \(photoURL)")
             // ...
             }*/
            // [END_EXCLUDE]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //***********************************************************************************************************
    //Metodos de FBSDKLogin
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if result.isCancelled{
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        accedeFirebaseFromFB(credencial: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    //***********************************************************************************************************
    //Metodos generales
    /**
     Crea elemetos de la la interfaz de usuario mediante codigo
     */
    func creaUI() {
        //Configura el boton de acceso para facebook
        let buttonText = NSAttributedString(string: "Accede con Facebook")
        loginButtonFb.setAttributedTitle(buttonText, for: .normal)
        let origen = CGPoint(x: btnIngresar.frame.minX, y: btnIngresar.frame.maxY + 60)
        let tamano = CGSize(width: btnIngresar.frame.width, height: btnIngresar.frame.height)
        loginButtonFb.frame = CGRect(origin:origen, size: tamano)
        loginButtonFb.center = CGPoint(x: view.frame.midX, y: btnIngresar.frame.maxY + 50)
        loginButtonFb.delegate = self
        //Crea un Label para indicar al usuario que no publicaremos nada en su nombre
        let label = UILabel()
        label.text = "Nunca publicaremos nada en tu nombre"
        label.font = UIFont(name: "Ubuntu-Regular", size: 14)
        label.frame = CGRect(x: loginButtonFb.frame.minX - 4, y: loginButtonFb.frame.maxY , width: 300, height: 50)
        view.addSubview(loginButtonFb)
        view.addSubview(label)
    }
    
    /**
     Remueve el foco de los campos de texto , permitiendo aultar del teclado
     */
    @objc func quitaFocoTextFields(){
        textFielCorreo.resignFirstResponder()
        textFieldContrasena.resignFirstResponder()
    }
    /**
     Determina cual campo de texto es el faltantes
     - Parameter correo: correo que ingreso el usuario
     - Parameter contrasena: contrasena que ingreso el usuario
     - Returns : 0 contraseña y correo faltantes , 1 correo faltante, 2 contraseña flatante
     */
    func validaCampofaltante(correo:String,contrasena:String) -> Int {
        if !correo.isEmpty && !contrasena.isEmpty {
            return 3
        }else if correo.isEmpty && contrasena.isEmpty {
            return 0
        }else if correo.isEmpty {
            return 1
        }else{
            return 2
        }
    }
    /**
     Resetea el contenido de los campos de texto
     */
    func limpaTextFields() {
        textFielCorreo.text = ""
        textFieldContrasena.text = ""
    }
    
    /**
     Autentificacion por correo electronico
     - Parameter correo : rieccion de correo electronico que ingreso el usuario
     - Parameter contrasena : contraseña que ingreso el usuario
     */
    @objc func accesoPorCorreo(correo:String,contrasena:String) {
        Auth.auth().signIn(withEmail: correo, password: contrasena) { (user, error) in
            if let error = error{
                self.miAlertDialog.alertDialogUnBoton(titulo: "¡Opps!", mensaje: error.localizedDescription, view: self)
            }
        }
    }
    
    /**
     Autentifica al usuario en farebase mediate Facebook
     - Parameter credencial : credenciales obtenidas de la autentificacion en Facebook
     */
    func accedeFirebaseFromFB(credencial:AuthCredential) {
        Auth.auth().signIn(with: credencial) { (user, error) in
            if let error = error {
                // ...
                self.miAlertDialog.alertDialogUnBoton(titulo: "¡Opps!", mensaje: error.localizedDescription, view:self)
                print(error.localizedDescription)
                return
            }
            // User is signed in
            if user != nil{
                PreferenciasDeUsuario.setLogueadoFB(logueado: true)
                //Intancia el storyboard
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                //Instancia del view controler correspondiente al tabBarController
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarViewController")
                //Intacia de uiAplication
                let uiApp = UIApplication.shared.delegate as! AppDelegate
                uiApp.window?.rootViewController = tabBarController
            }
        }
    }
    
    //****************************************************************************************************************
    //Accions
    
    @IBAction func onBtnIngresar(_ sender: Any) {
        quitaFocoTextFields()
        let correo = textFielCorreo.text!
        let contrasena = textFieldContrasena.text!
        switch validaCampofaltante(correo: correo, contrasena: contrasena) {
        case 0:
            //Contraseña y correo no ingresados
            miAlertDialog.alertDialogUnBoton(titulo: "¡Oops!", mensaje: "Los campos de correo y contraseña son requeridos", view: self)
            limpaTextFields()
        case 1:
            //Correo no ingresado
            limpaTextFields()
            miAlertDialog.alertDialogUnBoton(titulo: "¡Oops!", mensaje: "El campo correo es requerido", view: self)
        case 2:
            //Contraseña no ingresada
            limpaTextFields()
            miAlertDialog.alertDialogUnBoton(titulo: "¡Oops!", mensaje: "El campo contraseña es requerido", view: self)
        default:
            //determina si la direccion de correo ingresada es valida
            let ragex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let esCorreo = NSPredicate(format: "SELF MATCHES %@", ragex)
            if esCorreo.evaluate(with: correo){
                accesoPorCorreo(correo: correo, contrasena: contrasena)
            }else{
                //El correo electronico ingresado no tiene un formato valido
                limpaTextFields()
                miAlertDialog.alertDialogUnBoton(titulo: "¡Datos no válidos!", mensaje: "Ingresa una cuenta de correo válida", view: self)
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
