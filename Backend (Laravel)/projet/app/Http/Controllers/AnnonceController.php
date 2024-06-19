<?php

namespace App\Http\Controllers;
use App\Models\Annonce;
use App\Models\Enseignant;
use App\Models\Eleve;
use App\Models\Room;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Auth;
use Illuminate\Support\Str;

class AnnonceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($id)
    {   
        $data=[];
        $annonces=Annonce::where('room_id', $id)->orderBy('id','DESC')->get();
       
        for($i = 0; $i <  count($annonces); $i++){
            if($annonces[$i]->enseignant_id){
                $enst=Enseignant::where('id', $annonces[$i]->enseignant_id)->first();
                $display_contenent = explode(' ', Str::limit($annonces[$i]->contenu, 20));
                $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

                $display_title = explode(' ', Str::limit($annonces[$i]->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $annonces[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $annonces[$i]->titre,
                "contenu"=>  $annonces[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $annonces[$i]->file_path,
                "file_name"=> $annonces[$i]->file_name,
                "enseignant_id"=>  $annonces[$i]->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $annonces[$i]->room_id,
                "created_at"=> $annonces[$i]->created_at,
                "updated_at"=> $annonces[$i]->updated_at,
                
                 
             ];
         
          
            
             array_push($data,$obj);

            }
            
        }
  
    return response()->json(
        $data
        ,200);
       
    }
    public function index_limite($id)
    {   
        $data=[];
        $annonces=Annonce::where('room_id', $id)->orderBy('id','DESC')
        ->skip(0)
        ->take(5)
        ->get();
        for($i = 0; $i <  count($annonces); $i++){
            if($annonces[$i]->enseignant_id){
                $enst=Enseignant::where('id', $annonces[$i]->enseignant_id)->first();
                $display_contenent = explode(' ', Str::limit($annonces[$i]->contenu, 20));
                $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

                $display_title = explode(' ', Str::limit($annonces[$i]->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $annonces[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $annonces[$i]->titre,
                "contenu"=>  $annonces[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $annonces[$i]->file_path,
                "file_name"=> $annonces[$i]->file_name,
                "enseignant_id"=>  $annonces[$i]->enseignant_id,
                "enseignant_nom"=>  $enst->nom,
                "enseignant_prenom"=>  $enst->prenom,
                "room_id"=> $annonces[$i]->room_id,
                "created_at"=> $annonces[$i]->created_at,
                "updated_at"=> $annonces[$i]->updated_at,
                
                 
             ];
         
          
            
             array_push($data,$obj);

            }
            
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
       $enst=Enseignant::where('user_id', Auth::user()->id)->first();
       $fields= $request->validate([
            'titre'=> 'required|string',
            'contenu'=> 'required|string',
            'room_id'=> 'required',
        ]);
        if($request->file){ 
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersAnnonces', $original_name);
           $new_file_path = 'public/fichiersAnnonces/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            //return $file->getClientOriginalName();
            $annonce=Annonce::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'enseignant_id'=> $enst->id,
                'classe_id'=>$request->classe_id,
                'room_id'=>$request->room_id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName()
                           
            ]);
           
        }else{
            $annonce=Annonce::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'enseignant_id'=> $enst->id,
                'room_id'=>$request->room_id,
                'classe_id'=>$request->classe_id,
                
                           
            ]);

        }
       
       
        if($annonce){
            $enst=Enseignant::where('id', $annonce->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($annonce->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($annonce->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
       
        
         $obj=[
            "id"=> $annonce->id,
            "titre_resume"=> $display_title,
            "titre"=> $annonce->titre,
            "contenu"=>  $annonce->contenu,
            "contenu_resume"=>  $display_contenent,
            "file_path"=> $annonce->file_path,
            "file_name"=> $annonce->file_name,
            "enseignant_id"=>  $annonce->enseignant_id,
            "enseignant_nom"=>  $enst->nom,
            "enseignant_prenom"=>  $enst->prenom,
            "room_id"=> $annonce->room_id,
            "created_at"=> $annonce->created_at,
            "updated_at"=> $annonce->updated_at,
            
             
         ];
           
           return response()->json([
                $obj
            ],200);
        }else{
            return response()->json([
                "message"=>"annonce n a pas ete crée"
            ],401);

        }
    }
    public function storeAgt(Request $request)
    {  
      
       $fields= $request->validate([
            'titre'=> 'required|string',
            'contenu'=> 'required|string',
            'classe_id'=> 'required',
        ]);
        if($request->file){ 
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersAnnonces', $original_name);
           $new_file_path = 'public/fichiersAnnonces/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            //return $file->getClientOriginalName();
            $annonce=Annonce::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'classe_id'=>$request->classe_id,
                'file_path'=> $new_file_path,
                'file_name' => $file->getClientOriginalName()
                           
            ]);
           
        }else{
            $annonce=Annonce::create([
                'titre'=>$fields['titre'],
                'contenu'=>$fields['contenu'],
                'classe_id'=>$request->classe_id,
                
                           
            ]);

        }
       
       
        if($annonce){
           response()->json(
                $annonce
            ,200);
        }else{
            return response()->json([
                "message"=>"annonce n a pas ete crée"
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
        
        // chercher l'annonce  dans une room donnée
        $annonce=Annonce::where(function ($query) use ($id,$id_room) {
            $query->where('id',  $id);
            $query->where('room_id', $id_room);
        })->first();
        if($annonce){
            return response()->json([
                'data'=>$annonce
            ],200);
        }else{
            return response()->json([
                "message"=>"l'annonce n'existe pas"
            ],401);

        }
    }
    public function show_file($id)
    {
       
        // chercher le support  
        $annonce=Annonce::Find($id);
        if($annonce){
        $file_path=$annonce->file_path;
        if(Storage::exists($file_path)){
            $file=Storage::get($annonce->file_path);
            $response = Response::make($file,200);
            $response->header('Content-Type', 'application/octet-stream');
            return $response;
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"l'annonce n'existe pas"
            ],401);
        }
        
       
    }
    
    public function downoald_file($id)
    {
       
        
        $annonce=Annonce::Find($id);
        if($annonce){
        $file_path=$annonce->file_path;
        if(Storage::exists($file_path)){
           
            return Storage::download($file_path);
            
        }else{
            return response()->json([
                "message"=>"le fichier n'existe pas"
            ],401);
        }}else{
            return response()->json([
                "message"=>"l'annonce n'existe pas"
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
        $annonce=Annonce::Find($id);
        if($annonce){
        $old_file=$annonce->file_path;
        if($request->file){ 
           // dd($old_file);
            //dd(Storage::exists($old_file));
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersAnnonces', $original_name);
           $new_file_path = 'public/fichiersAnnonces/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $annonce->update([
                'file_path'=> $new_file_path,
                
            ]);
            $annonce->file_name=$file->getClientOriginalName();
            $annonce->save();
        }
        if($annonce->update($request->all())){
            
            $enst=Enseignant::where('id', $annonce->enseignant_id)->first();
            $display_contenent = explode(' ', Str::limit($annonce->contenu, 20));
            $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

            $display_title = explode(' ', Str::limit($annonce->titre, 22));
            $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
       
        
         $obj=[
            "id"=> $annonce->id,
            "titre_resume"=> $display_title,
            "titre"=> $annonce->titre,
            "contenu"=>  $annonce->contenu,
            "contenu_resume"=>  $display_contenent,
            "file_path"=> $annonce->file_path,
            "file_name"=> $annonce->file_name,
            "enseignant_id"=>  $annonce->enseignant_id,
            "enseignant_nom"=>  $enst->nom,
            "enseignant_prenom"=>  $enst->prenom,
            "room_id"=> $annonce->room_id,
            "created_at"=> $annonce->created_at,
            "updated_at"=> $annonce->updated_at,
            
             
         ];
     return response()->json([
                $obj
            ],200);
        }else{
            return response()->json([
                "message"=>"l'annonce n'a pas ete modifiée"
            ],401);
        }  
              
                           
            
       
        
    }else{
        return response()->json([
            "message"=>"l'annonce n'existe pas pour pouvoir la modifier"
        ],401); 
    }
        
    }
    public function updateAgt(Request $request, $id)
    {
        $annonce=Annonce::Find($id);
        if($annonce){
        $old_file=$annonce->file_path;
        if($request->file){ 
           // dd($old_file);
            //dd(Storage::exists($old_file));
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
            $file = $request->file('file');
            $original_name = $file->getClientOriginalName();
           $fichier = $file->storeAs('public/fichiersAnnonces', $original_name);
           $new_file_path = 'public/fichiersAnnonces/' . uniqid() . '_' . $original_name;
           Storage::copy($fichier, $new_file_path);
            $annonce->update([
                'file_path'=> $new_file_path,
                
            ]);
            $annonce->file_name=$file->getClientOriginalName();
            $annonce->save();
        }
        if($annonce->update($request->all())){
            
           
     return response()->json([
                $annonce
            ],200);
        }else{
            return response()->json([
                "message"=>"l'annonce n'a pas ete modifiée"
            ],401);
        }  
              
                           
            
       
        
    }else{
        return response()->json([
            "message"=>"l'annonce n'existe pas pour pouvoir la modifier"
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
        
        $annonce=Annonce::Find($id);
        if ($annonce){
            $old_file=$annonce->file_path;
            if(Storage::exists($old_file)){
                Storage::delete($old_file);
            }
           
            if($annonce->delete()){
            return response()->json([
                "message"=>"annonce supprimée"
            ],200); 
        }else{
            return response()->json([
                "message"=>"l'annonce n'a pas ete supprimée"
            ],401); 
        }
        }else{
            return response()->json([
                "message"=>"l'annonce n'existe pas pour pouvoir la supprimer"
            ],401); 
        }
    }

    public function indexAnnonceAdministrative($id)
    {   
        $data=[];
        $user=Auth::user();
        if($user->status==="Enseignant"){
            
            $room=Room::where('id', $id)->first();
            $annonces=Annonce::where('classe_id', $room->classe_id)->orderBy('id','DESC')->get();
        }else  if($user->status==="Eleve"){
            $elv=Eleve::where('user_id', $id)->first();
            $annonces=Annonce::where('classe_id', $elv->classe_id)->orderBy('id','DESC')->get();
        }else{
            $elv=Eleve::where('id', $id)->first();
            $annonces=Annonce::where('classe_id', $elv->classe_id)->orderBy('id','DESC')->get();

        }
      
       
        for($i = 0; $i <  count($annonces); $i++){
           
                $display_contenent = explode(' ', Str::limit($annonces[$i]->contenu, 20));
                $display_contenent = implode(' ', array_slice($display_contenent, 0, 5));

                $display_title = explode(' ', Str::limit($annonces[$i]->titre, 22));
                $display_title = implode(' ', array_slice($display_title, 0, 3)). '...';
           
            
             $obj=[
                "id"=> $annonces[$i]->id,
                "titre_resume"=> $display_title,
                "titre"=> $annonces[$i]->titre,
                "contenu"=>  $annonces[$i]->contenu,
                "contenu_resume"=>  $display_contenent,
                "file_path"=> $annonces[$i]->file_path,
                "file_name"=> $annonces[$i]->file_name,
                "classe_id"=> $annonces[$i]->classe_id,
                "created_at"=> $annonces[$i]->created_at,
                "updated_at"=> $annonces[$i]->updated_at,
                
                 
             ];
         
          
            
             array_push($data,$obj);

            
            
        }
  
    return response()->json(
        $data
        ,200);
       
    }

}
