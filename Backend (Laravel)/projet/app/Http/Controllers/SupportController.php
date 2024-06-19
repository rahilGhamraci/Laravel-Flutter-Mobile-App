<?php

namespace App\Http\Controllers;
use App\Models\Support;
use App\Models\Enseignant;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Response;

use Auth;
use Illuminate\Support\Str;
class SupportController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {   
        $data=[];
        $supports=Support::where('room_id', $id)->orderBy('id','DESC')->get();
        for($i = 0; $i <  count($supports); $i++){
            $enst=Enseignant::where('id', $supports[$i]->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($supports[$i]->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($supports[$i]->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $supports[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $supports[$i]->titre,
                "contenu"=>  $supports[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $supports[$i]->file_path,
                "file_name"=> $supports[$i]->file_name,
                "enseignant_id"=>  $supports[$i]->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $supports[$i]->room_id,
                "created_at"=> $supports[$i]->created_at,
                "updated_at"=> $supports[$i]->updated_at,
                
                 
             ];
         
          
            
             array_push($data,$obj);
        }
  
    return response()->json(
        $data
        ,200);
    

        
    }

    public function index_limite($id)
    {   
        $data=[];
        $supports=Support::where('room_id', $id)->orderBy('id','DESC')
        ->skip(0)
        ->take(5)
        ->get();
        for($i = 0; $i <  count($supports); $i++){
            $enst=Enseignant::where('id', $supports[$i]->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($supports[$i]->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($supports[$i]->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $supports[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $supports[$i]->titre,
                "contenu"=>  $supports[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $supports[$i]->file_path,
                "file_name"=> $supports[$i]->file_name,
                "enseignant_id"=>  $supports[$i]->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $supports[$i]->room_id,
                "created_at"=> $supports[$i]->created_at,
                "updated_at"=> $supports[$i]->updated_at,
                
                 
             ];
         
          
            
             array_push($data,$obj);
        }
  
    return response()->json(
        $data
        ,200);
        
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $fields= $request->validate([
            'titre'=> 'required|string',
            'contenu'=> 'required|string',
            'file'=>'required',
            'room_id'=> 'required',
        ]);
        $enst=Enseignant::where('user_id', Auth::user()->id)->first();
        
        $file = $request->file('file');
        $original_name = $file->getClientOriginalName();
       $fichier = $file->storeAs('public/Supports', $original_name);
       $new_file_path = 'public/Supports/' . uniqid() . '_' . $original_name;
       Storage::copy($fichier, $new_file_path);
            
            //return  $file->getClientOriginalName();
            $support=Support::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'enseignant_id'=>  $enst->id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName(),
                'room_id'=>$request->room_id,     
            ]);
        
       
       
            if($support){
                $enst=Enseignant::where('id', $support->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($support->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($support->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $support->id,
                "titre_resume"=> $display_title,
                "titre"=> $support->titre,
                "contenu"=>  $support->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $support->file_path,
                "file_name"=> $support->file_name,
                "enseignant_id"=>  $support->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $support->room_id,
                "created_at"=> $support->created_at,
                "updated_at"=> $support->updated_at,
                
                 
             ];
              
                return response()->json([
                    $obj
                ],200);
            }else{
                return response()->json([
                    "message"=>"le support n'a pas ete crée"
                ],401);
    
            }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id,$id_room)
    {
       
        // chercher le support  dans une room donnée
        $support=Support::where(function ($query) use ($id,$id_room) {
            $query->where('id',  $id);
            $query->where('room_id', $id_room);
        })->first();
         
       
        if($support){
            return response()->json([
                "data"=>$support,
                
            ],200);
        }else{
            return response()->json([
                "message"=>"le support n'existe pas"
            ],401);

        }
    }

    public function show_file($id)
    {
       
        // chercher le support  dans une room donnée
        $support=Support::where('id',  $id) ->first();
         
        //retourner le support avec le fichier codé !!!!!!!!!
        
        $filePath = storage_path('app/'.$support->file_path);
        $fileContents = base64_encode(file_get_contents($filePath));
        return response()->json(
        ["file" =>$fileContents],200);
    }

    public function downoald_file($id)
    {
       
        // chercher le support  
        $support=Support::Find($id);
        if($support){
        $file_path=$support->file_path;
        //return $file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"le support n'existe pas"
            ],401);
        }
        
       
    }
    

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $support=Support::Find($id);
        if($support){
        $old_file=$support->file_path;
        if($request->file){ 
           //supprimer l'ancien fichier
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/Supports', $original_name);
           $new_file_path = 'public/Supports/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
                
            $support->update([
                'file_path'=> $new_file_path,
               
            ]);
            $support->file_name=$file->getClientOriginalName();
            $support->save();
        }
        if($support->update($request->all())){
            $enst=Enseignant::where('id', $support->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($support->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($support->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $support->id,
                "titre_resume"=> $display_title,
                "titre"=> $support->titre,
                "contenu"=>  $support->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $support->file_path,
                "file_name"=> $support->file_name,
                "enseignant_id"=>  $support->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $support->room_id,
                "created_at"=> $support->created_at,
                "updated_at"=> $support->updated_at,
                
                 
             ];
              
                return response()->json([
                    $obj
                ],200);
        }else{
            return response()->json([
                "message"=>"le support n'a pas ete modifié"
            ],401);
        }  
              
                           
            
       
        
    }else{
        return response()->json([
            "message"=>"le support n'existe pas pour pouvoir le modifier"
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
       
        $support=Support::Find($id);
        if ($support){
            $old_file=$support->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            if($support->delete()){
                return response()->json([
                    "message"=>"support supprimé"
                ],200); 
            }else{
                return response()->json([
                    "message"=>"le support n'a pas ete supprimé"
                ],401); 
            }
        }else{
            return response()->json([
                "message"=>"le support n'existe pas pour pouvoir le supprimer"
            ],401);
        }
    }
}
