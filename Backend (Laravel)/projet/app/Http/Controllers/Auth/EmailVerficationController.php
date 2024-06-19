<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Otp;
use Mail;
use App\Mail\MailNotify;


class EmailVerficationController extends Controller
{
    public $otp;
    public function __construct()
    {
   
        $this->otp=new Otp;
    }

    

public function verify(Request $request){
    $fields= $request->validate([
        'email'=> 'required|email',
    ]);

  
   
    try {
        $otp=$this->otp->generate($fields['email'],6,60);
    $data=[
        'subject' =>'OurClass- Vérification Adresse mail',
        'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff; font-size: 14px;">' .
        "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/1360d10a-779d-4575-8fdb-9b7f40b0a3e2/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
        style=\"max-width: 30%; display: block; margin: 0 auto;\">".
        "<h2>Bonjour,</h2>" .
        "<p>Merci de votre intérêt pour notre application ! Pour finaliser votre inscription et confirmer</p>" .
        "<p>votre identité, veuillez utiliser le code de vérification suivant lors du processus d'inscription : </p>" .
        "<p>".$otp->token."</p>" .
        "<p>Copiez ce code et collez-le dans le champ prévu à cet effet lors de votre inscription. </p>" .
        "<p>Assurez-vous de l'entrer correctement pour valider votre compte.</p>".
        "<p>Nous vous remercions de votre collaboration et de votre confiance. Si vous avez des questions ou besoin d'aide supplémentaire, n'hésitez pas à nous contacter.</p>".
        "<p>Cordialement,</p>".
        "<p>L'équipe de OurClass</p>".
        '</div>',

    ];
        Mail::to($fields['email'])->send(new MailNotify($data));
        return response()->json(['success' => true],200);

    } catch (\Exception $th) {
        return response(
            $th
          ,401);
    }
  


}
}