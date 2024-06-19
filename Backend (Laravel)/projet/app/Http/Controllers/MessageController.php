<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Message;
use Auth;
use Illuminate\Support\Str;
use App\Events\NewMessageEvent;

class MessageController extends Controller
{
    /**
     * Retourner les messages d'une connversation donnée.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {   
        $data=[];
        $messages=Message::where(function ($query) use ($id) {
            $query->where('conversation_id', $id);
            $query->orderBy('created_at', 'asc');
           
             })->get();
        for($i = 0; $i <  count($messages); $i++){
            if($messages[$i]->user_id==Auth::user()->id){
               $type="Sender";
            }else{
               $type="Receiver";
               }
               if($messages[$i]->read==1 || $messages[$i]->read){
                $read=true;
            }else{
                $read=false;
            }
           
            if( $messages[$i]->updated_at!=null){
                $date2=$messages[$i]->updated_at->format('d/m/Y H:i:s');
            }else{
                $date2=null;
            }
            if($messages[$i]->reponse != null){
                $display_message = explode(' ', Str::limit($messages[$i]->reponse, 20));
                $display_message = implode(' ', array_slice($display_message, 0, 2)).'...';
            }else{
                $display_message=null;
            }
            
            $obj=[
                'id'                    => $messages[$i]->id,
                'contenu'               => $messages[$i]->contenu,
                'read'                  => $read,
                'user_id'               =>$messages[$i]->user_id,
                'conversation_id'       => $messages[$i]->conversation_id,
                'created_at'            => $messages[$i]->created_at,
                'updated_at'            => $date2,
                'type'                  => $type,
                'reponse'               =>$display_message 
                
            ];
            array_push($data,$obj);

        }
  
  
      return response()->json(
      $data
      ,200);
  }

    /**
     * Créer un message.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {    
       
        $fields= $request->validate([
            'conversation_id'=> 'required',
            'contenu'=> 'required|string',

        ]);

        $message=Message::create([
            'user_id'=>Auth::user()->id,
            'conversation_id'=> $fields['conversation_id'],
            'contenu'=> $fields['contenu'],
            'read'=> false,
            'reponse'=> $request->reponse,
                    
        ]);
        if($message){
          
            if($message->reponse != null){
                $display_message = explode(' ', Str::limit($message->reponse, 20));
                $display_message = implode(' ', array_slice($display_message, 0, 2)).'...';
            }else{
                $display_message=null;
            }
            
             $obj=[
                 'id'                    => $message->id,
                 'contenu'               => $message->contenu,
                 'read'                  => $message->read,
                 'user_id'               =>$message->user_id,
                 'conversation_id'       => $message->conversation_id,
                 'created_at'            =>  $message->created_at ,
                 'updated_at'            => $message->updated_at->format('d/m/Y H:i:s'),
                 'type'                  => "Sender",
                 'reponse'=> $display_message,
                 
             ];
             //broadcast(new NewMessageEvent($obj))->toOthers();
           
             event(new NewMessageEvent($obj));
            return response()->json([
                $obj
            ],200);
        }else{
            return response()->json([
                "message"=>"le message n a pas ete envoyé"
            ],401);

        }
    }

    /**
     * Rechercher un  message dans une conversation donnée.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id,$word)
    {
        $messages=Message::where(function ($query) use ($word,$id) {
            $query->where('conversation_id',  $id);
            $query->where('contenu',  'like',  '%' . $word .'%');
         
        })->get();
        return response([
            "data"=>$messages
        ],200);
    }

    /**
     * Modifier un message.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $message=Message::find($id);
        if($message){
            $message->contenu=$request->contenu;
            $message->save();
            return response([
                "data"=>$message
            ],200);
        }
    }

    /**
     * Supprimer un message.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $message=Message::find($id);
        if($message){
            if($message->delete()){
                return response()->json([
                    "message"=>"message supprimé"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"le message n'a pas ete supprimé"
                ],401); 
            }
        }
    }
}
