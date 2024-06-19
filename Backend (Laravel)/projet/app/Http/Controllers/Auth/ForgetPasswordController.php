<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Notifications\ResetPasswordVerificationNotification;
use Otp;
use Mail;
use App\Mail\ForgetPassword;

class ForgetPasswordController extends Controller
{   
    public $otp;
    public function __construct()
    {
   
        $this->otp=new Otp;
    }
    public function forgetPassword(Request $request){
        $fields= $request->validate([
            'email'=> 'required|email|exists:users',
        ]);

        $user=User::where('email',$fields['email'])->first();
        //return $user;
        try {
            $otp=$this->otp->generate($fields['email'],6,60);
        $data=[
            'subject' =>'OurClass- Récupération mot de passe',
            'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff; font-size: 14px;">' .
            "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/1360d10a-779d-4575-8fdb-9b7f40b0a3e2/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
            style=\"max-width: 30%; display: block; margin: 0 auto;\">".
            "<h2>Bonjour,</h2>" .
            "<p>Utilisez le code ci-dessous pour récupérer votre mot de passe.</p>" .
            "<p>Code: ".$otp->token."</p>" .
            "<p>Cordialement,</p>" .
            "<p>[L'équipe OurClass]</p>".
            '</div>',

        ];
            Mail::to($user->email)->send(new ForgetPassword($data));
            return response()->json(['success' => true],200);

        } catch (\Exception $th) {
            return response(
                $th
              ,401);
        }
       // $user->notify(new ResetPasswordVerificationNotification());
    

    }
}
