<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Otp;
use Illuminate\Support\Facades\Hash;

class ResetPasswordController extends Controller
{  
    private $otp;
    public function __construct(){
        $this->otp= new Otp;
    }
    public function resetPassword(Request $request){
        $fields= $request->validate([
          
            'email'=> 'required|email|exists:users',
            'otp'=> 'required|max:6',
            'password'=> 'required|string',
        ]);
        $otp2=$this->otp->validate($fields['email'],$fields['otp']);
        if(! $otp2->status){
            return response()->json(['error'=> $otp2],401);

        }
        $user=User::where('email',$fields['email'])->first();
        $hashedPassword= hash('sha256', $fields['password']);
        $user->update(['password'=> $hashedPassword]);
        $user->tokens()->delete();
        return response()->json(['success' => true],200);



    }
   
}
