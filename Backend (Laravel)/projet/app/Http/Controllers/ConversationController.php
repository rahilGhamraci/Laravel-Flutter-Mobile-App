<?php

namespace App\Http\Controllers;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\User;
use App\Models\Eleve;
use App\Models\Enseignant;
use App\Models\Tuteur;
use App\Models\Room;
use Auth;

class ConversationController extends Controller
{
    /**
     * Retourner toutes les conversations de l'utilisateur  connecté 
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
     $data=[];
     //recuperer toutes les conversations
     $conversations=Conversation::where(function ($query) {
     $query->where('first_user_id', Auth::user()->id)
    ->orWhere('second_user_id',Auth::user()->id);
      })->get();
    
    
      // trier les conversations
      for($i=0;$i< count($conversations);$i++){
        for($j=$i+1;$j< count($conversations);$j++){

            $last_msg_conv1=Message::where('conversation_id', $conversations[$i]->id)->latest('id')->first();
            $last_msg_conv2=Message::where('conversation_id', $conversations[$j]->id)->latest('id')->first();
           
            if($last_msg_conv1 < $last_msg_conv2){
               $temp=$conversations[$i];
               $conversations[$i]=$conversations[$j];
               $conversations[$j]=$temp;
            }

        }

      }
     // donner aux données un certain format pour pouvoir les exploiter dans le front
    for ($i = 0; $i <  count($conversations); $i++) {
        $last_msg_conv=Message::where('conversation_id', $conversations[$i]->id)->latest('id')->first();
        if($conversations[$i]->first_user_id==Auth::user()->id){
          $other_user=User::where('id', $conversations[$i]->second_user_id)->first();
        }else{
          $other_user=User::where('id', $conversations[$i]->first_user_id)->first();
        }
        //verifier que le compte de l'autre utilisateur existe toujours et n'a pas ete supprimé
        if ($other_user){
            $user_name=$other_user->name;
        }else{
            $user_name="Utilisateur inconnu";
        }
        //verifier que la conversation contient le message
         if($last_msg_conv){
            $display_message = explode(' ', Str::limit($last_msg_conv->contenu, 25));
            $display_message = implode(' ', array_slice($display_message, 0, 5));
          
          $obj=[
          'id'                    => $conversations[$i]->id,
          'first_user_id'          => $conversations[$i]->first_user_id,
          'second_user_id'         => $conversations[$i]->second_user_id,
          'contenu_msg'            => $display_message,
          'user_id_msg'            => $last_msg_conv->user_id,
          'date_msg'               => $last_msg_conv->created_at ,
          'read'                   =>$last_msg_conv->read,
          'user_name'              => $user_name
          
      ];
    }else{
        $obj=[
            'id'                    => $conversations[$i]->id,
            'first_user_id'          => $conversations[$i]->first_user_id,
            'second_user_id'         => $conversations[$i]->second_user_id,
            'contenu_msg'            => null,
            'user_id_msg'            => null,
            'date_msg'               => null,
            'read'                   =>null,
            'user_name'              => $user_name,
        ];
    }

      array_push($data,$obj);

          }
    
    
        return response()->json(
        $data
        ,200);
    }

    /**
     * Creer une nouvelle conversation avec un autre utilisateur.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $fields= $request->validate([
            'second_user_id'=> 'required',
            
        ]);
        $id=$fields['second_user_id'];
        //verifier s'il existe deja une conversation entre ces deux utilisateur
        $conversation= Conversation::where(function ($query) use ($id){
            $query->where('first_user_id', Auth::user()->id);
            $query->Where('second_user_id',$id);
        })->orWhere(function ($query) use ($id) {
            $query->where('first_user_id', $id);
            $query->Where('second_user_id',Auth::user()->id);
        })->first();
       
        if($conversation){
           

            if($conversation->first_user_id==Auth::user()->id){
                $other_user=User::where('id', $conversation->second_user_id)->first();
              }else{
                $other_user=User::where('id', $conversation->first_user_id)->first();
              }

              $obj=[
                'other_user_id'=> $other_user->id,
                'other_user_name'=> $other_user->name,
                'id'=>$conversation->id,

            ];
            return response()->json(
               $obj
                
            ,200);
        }
            $conversation=Conversation::create([
                'first_user_id'=>Auth::user()->id,
                'second_user_id'=> $fields['second_user_id'],
                        
            ]);

           
        
       
       
            if($conversation){
                $user=User::where('id', $conversation->second_user_id)->first();
                $obj=[
                    'other_user_id'=> $user->id,
                    'other_user_name'=> $user->name,
                    'id'=>$conversation->id,

                ];
               
                return response()->json(
                    
                        $obj
                    
                    
                    
                ,200);
            }else{
                return response()->json([
                    "message"=>"la conversation n'a pas ete crée"
                ],401);
    
            }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {   
        //chercher la conversation entre l'utilisateur connecté avec la personne qu'il souhaite trouver sa conversation
        $conversation= Conversation::where(function ($query) use ($id){
            $query->where('first_user_id', Auth::user()->id);
            $query->Where('second_user_id',$id);
        })->orWhere(function ($query) use ($id) {
            $query->where('first_user_id', $id);
            $query->Where('second_user_id',Auth::user()->id);
        })->first();
       
        $messages=Message::where('conversation_id', $conversation->id)->get();
        if($conversation){
            return response()->json([
                'data'=>$conversation,
                'messages'=>$messages
            ],200);
        }else{
            return response()->json([
                "message"=>"la conversation n'existe pas"
            ],401);

        }
    }

    

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }

    public function markAsReaded($id){
     
      
      $conversation=Conversation::find($id);
      $id_conv=$conversation->id;
      $first_user=$conversation->first_user_id;
      $second_user=$conversation->second_user_id;
      if(Auth::user()->id==$first_user){
        $messages= Message::where(function ($query) use ($second_user,$id_conv){
            $query->where('user_id', $second_user);
            $query->Where('conversation_id',$id_conv);
        })->get();
      }else{
        if(Auth::user()->id==$second_user){
            $messages= Message::where(function ($query) use ($first_user,$id_conv){
                $query->where('user_id', $first_user);
                $query->Where('conversation_id',$id_conv);
            })->get();
        }
      }
     
      for($i=0;$i< count($messages);$i++){
        $messages[$i]->read=1;
        $messages[$i]->save();
      
      
    }
    }
    public function users()
    {  
        $data=[];
        $user=Auth::user();
        if($user->status==="Eleve"){
            $elv=Eleve::where('user_id',$user->id)->first();
            $rooms=Room::where('classe_id',$elv->classe_id)->get();
            for($i=0;$i<count($rooms);$i++){
                $enst=Enseignant::where('id',$rooms[$i]->enseignant_id)->first();
                $user1=User::where('id',$enst->user_id)->first();
                if(!in_array($user1, $data)){
                    array_push($data,$user1);
                }
                
            }

            return response()->json($data,200);

        }else if ($user->status==="Tuteur"){
            $tuteur=Tuteur::where('user_id',$user->id)->first();
            $elvs=Eleve::where('tuteur_id',$tuteur->id)->get();
            for($i=0;$i<count($elvs);$i++){
                $rooms=Room::where('classe_id',$elvs[$i]->classe_id)->get();
                for($j=0;$j<count($rooms);$j++){
                    $enst=Enseignant::where('id',$rooms[$j]->enseignant_id)->first();
                    $user1=User::where('id',$enst->user_id)->first();
                    if(!in_array($user1, $data)){
                        array_push($data,$user1);
                }
                
            }
                
            }
            return response()->json($data,200);


        } else if($user->status==="Enseignant"){
            $enst=Enseignant::where('user_id',$user->id)->first();
            $rooms=Room::where('enseignant_id',$enst->id)->get();
            for($i=0;$i<count($rooms);$i++){
                $elvs=Eleve::where('classe_id',$rooms[$i]->classe_id)->get();
                for($j=0;$j<count($elvs);$j++){
                    $tuteur=Tuteur::where('id',$elvs[$j]->tuteur_id)->first();
                    $user1=User::where('id',$elvs[$j]->user_id)->first();
                    $user2=User::where('id',$tuteur->user_id)->first();
                    if(!in_array($user1, $data) && $user1){
                        array_push($data,$user1);
                }
                if(!in_array($user2, $data) && $user2){
                    array_push($data,$user2);
            }

                }
               
            
        }
        return response()->json($data,200);

        }
     
    }
}
