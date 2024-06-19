<?php

namespace App\Http\Controllers;
use App\Models\User;
use App\Models\Classe;
use App\Models\Tuteur;
use App\Models\Eleve;
use App\Models\Etablissement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use \Illuminate\Support\Str;
use Mail;
use App\Mail\MailNotify;
use Otp;

class AuthController extends Controller
{    
    /**
    * Creer un compte pour l'eleve.
    *
    * @return \Illuminate\Http\Response
    */
    private $otp;
    public function __construct(){
        $this->otp= new Otp;
    }
    public function register(Request $request){
        $fields= $request->validate([
            'name'=> 'required|string',
            'email'=> 'required|email|unique:users,email',
            'id'=> 'required',
            'etablissement_id'=> 'required',
            'password'=> 'required|string|confirmed',
            'otp'=> 'required|max:6',
        ]);

        $otp2=$this->otp->validate($fields['email'],$fields['otp']);
        if(! $otp2->status){
            return response()->json(['error'=> $otp2],401);

        }
        //confirmer que l'eleve appartien à l'etablissemnt indiqué
       
        $id=$fields['id'];
        $classes=Classe::select('id')->where('etablissement_id', $fields['etablissement_id'])->get();
        $eleve=Eleve::where(function ($query) use ($id,$classes) {
            $query->where('id',$id);
            $query->whereIn('classe_id', $classes);
           
        })->first();
       
        if($eleve){
            $hashedPassword= hash('sha256', $fields['password']);
            $user=User::create([
            'name'=>$fields['name'],
            'email'=>$fields['email'],
            'password'=> $hashedPassword,
            'status'=>'Eleve'
        ]);
       
        if(!$user){
            return response([
                "message"=>"utilisateur non enregistré"
            ],401);
        }
        $eleve->user_id =$user->id;
        $eleve->save();
        $token=$user->createToken('appToken')->plainTextToken;
      
        $obj=[
            "id"=> $user->id,
            "name"=> $user->name,
            "email"=> $user->email,
            "status"=> $user->status,
            "token"=>$token,
        ];
        $data=[
            'subject' => 'Bienvenue dans OurClass - Votre application pour une expérience éducative optimale !',
            'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff;font-size: 14px;">' .
            "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/1360d10a-779d-4575-8fdb-9b7f40b0a3e2/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
            style=\"max-width: 30%; display: block; margin: 0 auto;\">".
            "<h2>Cher(e) ,".$eleve->prenom."</h2>" .
            "<p>Nous sommes ravis de vous accueillir dans la famille OurClass ! En tant que nouvel utilisateur de notre application, vous avez désormais accès à une plateforme exceptionnelle qui réunit toute la famille pédagogique pour une expérience éducative optimale.</p>" .
            "<p>OurClass a été conçu pour faciliter votre parcours éducatif, que vous soyez un étudiant, un parent ou un enseignant. Nous sommes déterminés à vous offrir les meilleurs outils et fonctionnalités pour rendre votre expérience d'apprentissage aussi enrichissante et agréable que possible.</p>" .
            "<p>Voici quelques-unes des fonctionnalités dont vous pouvez bénéficier dès maintenant :</p>" .
            "<ul>" .
            "<li>Gestion simplifiée des cours : Vous pouvez facilement consulter votre emploi du temps, accéder aux documents de cours, et rester à jour avec les annonces et les devoirs.</li>" .
            "<li>Communication efficace : Notre système de messagerie intégré vous permet de rester connecté avec vos enseignants.</li>" .
            "<li>Suivi de la progression : Grâce à notre fonctionnalité de suivi, vous pouvez suivre vos résultats scolaires, évaluer votre progression et mettre en évidence vos réalisations.</li>" .
            "</ul>" .
            "<p>Nous sommes constamment à l'écoute de nos utilisateurs, et nous mettons tout en œuvre pour améliorer continuellement notre application. Vos suggestions et vos commentaires sont précieux, alors n'hésitez pas à nous les transmettre à tout moment.</p>" .
            "<p>Pour commencer à profiter de tous ces avantages, veuillez vous connecter à votre compte OurClass en utilisant les informations d'identification que vous avez fournies lors de votre inscription.</p>" .
            "<p>Nous sommes impatients de vous voir évoluer et réussir avec OurClass. N'oubliez pas que vous faites désormais partie d'une communauté engagée dans l'excellence éducative.</p>" .
            "<p>Si vous avez des questions ou besoin d'assistance, notre équipe d'assistance est toujours là pour vous aider. N'hésitez pas à nous contacter à ourclassalgerie@gmail.com et nous vous répondrons dans les plus brefs délais.</p>" .
            "<p>Encore une fois, bienvenue dans la famille OurClass !</p>" .
            "<p>Cordialement,</p>" .
            "<p>[L'équipe OurClass]</p>".
            '</div>',
        ];
        try {
            Mail::to($user->email)->send(new MailNotify($data));
            return response(
                $obj
              ,200);

        } catch (\Exception $th) {
            return response(
                $th
              ,401);
        }
    }else{
        return response([
            "message"=>"vous appartenez pas a l'etablissement indiqué"
        ],401);
    }

    }
    /**
    * Creer un compte pour le tuteur.
    *
    * @return \Illuminate\Http\Response
    */
    public function register_tuteur(Request $request){
        $fields= $request->validate([
            'name'=> 'required|string',
            'email'=> 'required|email|unique:users,email',
            'nss'=> 'required',
            'password'=> 'required|string|confirmed',
        ]);
        //confirmer que le tuteur  est enregistré dans la bdd cad a un enfant scolarisé
       
        $nss=$fields['nss'];
        $tuteur=Tuteur::where('nss',$nss)->first();
        
        if($tuteur){
            $hashedPassword= hash('sha256', $fields['password']);
        $user=User::create([
            'name'=>$fields['name'],
            'email'=>$fields['email'],
            'password'=>  $hashedPassword,
            'status'=>'Tuteur'
        ]);
       
        if(!$user){
            return response([
                "message"=>"utilisateur non enregistré"
            ],401);
        }
        $tuteur->user_id =$user->id;
        $tuteur->save();
        $token=$user->createToken('appToken')->plainTextToken;
    
        $obj=[
            "id"=> $user->id,
            "name"=> $user->name,
            "email"=> $user->email,
            "status"=> $user->status,
            "token"=>$token,
        ];
        $data=[
            'subject' => 'Bienvenue dans OurClass - Votre application pour une expérience éducative optimale !',
            'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff; font-size: 14px;">' .
            "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/1360d10a-779d-4575-8fdb-9b7f40b0a3e2/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
            style=\"max-width: 30%; display: block; margin: 0 auto;\">".
            "<h2>Cher(e) ".$tuteur->prenom.",</h2>" .
            "<p>Nous sommes ravis de vous accueillir dans la famille OurClass ! En tant que nouvel utilisateur de notre application, vous avez désormais accès à une plateforme exceptionnelle qui réunit toute la famille pédagogique pour une expérience éducative optimale.</p>" .
            "<p>OurClass a été conçu pour faciliter votre parcours éducatif, que vous soyez un étudiant, un parent ou un enseignant. Nous sommes déterminés à vous offrir les meilleurs outils et fonctionnalités pour rendre votre expérience d'apprentissage aussi enrichissante et agréable que possible.</p>" .
            "<p>Voici quelques-unes des fonctionnalités dont vous pouvez bénéficier dès maintenant :</p>" .
            "<ul>" .
            "<li>Gestion simplifiée des cours : Vous pouvez facilement consulter votre emploi du temps, accéder aux documents de cours, et rester à jour avec les annonces et les devoirs.</li>" .
            "<li>Communication efficace : Notre système de messagerie intégré vous permet de rester connecté avec vos enseignants.</li>" .
            "<li>Suivi de la progression : Grâce à notre fonctionnalité de suivi, vous pouvez suivre vos résultats scolaires, évaluer votre progression et mettre en évidence vos réalisations.</li>" .
            "</ul>" .
            "<p>Nous sommes constamment à l'écoute de nos utilisateurs, et nous mettons tout en œuvre pour améliorer continuellement notre application. Vos suggestions et vos commentaires sont précieux, alors n'hésitez pas à nous les transmettre à tout moment.</p>" .
            "<p>Pour commencer à profiter de tous ces avantages, veuillez vous connecter à votre compte OurClass en utilisant les informations d'identification que vous avez fournies lors de votre inscription.</p>" .
            "<p>Nous sommes impatients de vous voir évoluer et réussir avec OurClass. N'oubliez pas que vous faites désormais partie d'une communauté engagée dans l'excellence éducative.</p>" .
            "<p>Si vous avez des questions ou besoin d'assistance, notre équipe d'assistance est toujours là pour vous aider. N'hésitez pas à nous contacter à ourclassalgerie@gmail.com et nous vous répondrons dans les plus brefs délais.</p>" .
            "<p>Encore une fois, bienvenue dans la famille OurClass !</p>" .
            "<p>Cordialement,</p>" .
            "<p>[L'équipe OurClass]</p>".
            '</div>',

        ];
        try {
            Mail::to($user->email)->send(new MailNotify($data));
            return response(
                $obj
              ,200);

        } catch (\Exception $th) {
            return response(
                $th
              ,401);
        }
       
    }else{
        return response([
            "message"=>"vous avez pas d'enfants scolarisés"
        ],401);
    }
}   
    
    public function login(Request $request){
        $fields= $request->validate([
            'email'=> 'required|email',
            'password'=> 'required|string',
        ]);
        $user=User::where('email',$fields['email'])->first();
      
        $hashedPassword = hash('sha256', $fields['password']);
        if(!$user || !($hashedPassword ===$user->password)){
            return response([
                "message"=>"informations erronées"
            ],401);
        }
        $token=$user->createToken('appToken')->plainTextToken;
        $obj=[
            "id"=> $user->id,
            "name"=> $user->name,
            "email"=> $user->email,
            "status"=> $user->status,
            "token"=>$token,
        ];
        return response(
          $obj
        ,200);

    }
   
    
    public function etabs(){
        $etabs=Etablissement::get();
        return response(
          $etabs
        ,200);
      }
    public function logout(Request $request){
      auth()->user()->tokens()->delete();
      return [
        "message"=>"logged out"
      ];
    }

    public function test(Request $request){
        $hashedPassword = hash('sha256', $request->password);
        return $hashedPassword ;
       /* $passwordFromDtabase = 'rahil123';
        $hashedPasswordFromDtabase = hash('sha256', $passwordFromDtabase);
        
        
        if($hashedPasswordFromDtabase===$hashedPassword ) {
            return response([
                "message"=>"correct password"
              ], 200);
        }else{
            return response([
                "message"=>"wrong password"
              ], 200);
        }*/
       
    }
    public function send(Request $request){
        $url='C:\wamp64\www\projet\public\images\6.jpg';
        $data=[
            'subject' => 'Bienvenue dans OurClass - Votre application pour une expérience éducative optimale !',
            'body' => '<div style="border: 1px solid #ccc; padding: 10px; text-align: center; background-color: #001920; color: #ffffff; font-size: 14px;">' .
            "<img src=\"https://cdn.cp.adobe.io/content/2/dcx/86c7fa17-c534-4348-9d33-10abecbb5fc5/rendition/preview.jpg/version/1/format/jpg/dimension/width/size/1200\"
            style=\"max-width: 50%; display: block; margin: 0 auto;\">".
            "<h2>Cher(e) Fayçal,</h2>" .
            "<p>Nous sommes ravis de vous accueillir dans la famille OurClass ! En tant que nouvel utilisateur de notre application, vous avez désormais accès à une plateforme exceptionnelle qui réunit toute la famille pédagogique pour une expérience éducative optimale.</p>" .
            "<p>OurClass a été conçu pour faciliter votre parcours éducatif, que vous soyez un étudiant, un parent ou un enseignant. Nous sommes déterminés à vous offrir les meilleurs outils et fonctionnalités pour rendre votre expérience d'apprentissage aussi enrichissante et agréable que possible.</p>" .
            "<p>Voici quelques-unes des fonctionnalités dont vous pouvez bénéficier dès maintenant :</p>" .
            "<ul>" .
            "<li>Gestion simplifiée des cours : Vous pouvez facilement consulter votre emploi du temps, accéder aux documents de cours, et rester à jour avec les annonces et les devoirs.</li>" .
            "<li>Communication efficace : Notre système de messagerie intégré vous permet de rester connecté avec vos enseignants.</li>" .
            "<li>Suivi de la progression : Grâce à notre fonctionnalité de suivi, vous pouvez suivre vos résultats scolaires, évaluer votre progression et mettre en évidence vos réalisations.</li>" .
            "</ul>" .
            "<p>Nous sommes constamment à l'écoute de nos utilisateurs, et nous mettons tout en œuvre pour améliorer continuellement notre application. Vos suggestions et vos commentaires sont précieux, alors n'hésitez pas à nous les transmettre à tout moment.</p>" .
            "<p>Pour commencer à profiter de tous ces avantages, veuillez vous connecter à votre compte OurClass en utilisant les informations d'identification que vous avez fournies lors de votre inscription.</p>" .
            "<p>Nous sommes impatients de vous voir évoluer et réussir avec OurClass. N'oubliez pas que vous faites désormais partie d'une communauté engagée dans l'excellence éducative.</p>" .
            "<p>Si vous avez des questions ou besoin d'assistance, notre équipe d'assistance est toujours là pour vous aider. N'hésitez pas à nous contacter à ghamracirahil@gmail.com et nous vous répondrons dans les plus brefs délais.</p>" .
            "<p>Encore une fois, bienvenue dans la famille OurClass !</p>" .
            "<p>Cordialement,</p>" .
            "<p>[L'équipe OurClass]</p>".
            '</div>',
        ];
        try {
            Mail::to('faycalbabaahmed197@gmail.com')->send(new MailNotify($data));
            return response(
                'mail envoyé'
              ,200);

        } catch (\Exception $th) {
            return response(
                $th
              ,401);
        }

    }

}
