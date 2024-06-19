<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Models\Note;
use App\Models\Eleve;
use App\Models\Tuteur;
use App\Models\Enseignant;
use App\Models\Matiere;
use Illuminate\Foundation\Http\FormRequest;
use Auth;

class NoteController extends Controller
{
    public function index($trimestre,$annee)
    
    {  
        $data=[];
        $elv=Eleve::where('user_id',Auth::user()->id)->first();
        $id=$elv->id;
        $notes = DB::table('notes')
        ->where('eleve_id', $id)
        ->where('trimestre', $trimestre)
        ->where('annee_scolaire', $annee)
        ->get();
        for($i = 0; $i <  count($notes); $i++){
            
             $obj=[
                 'id'                    => $notes[$i]->id,
                 'cc'                    => $notes[$i]->cc,
                 'tp'                    => $notes[$i]->TP,
                 'moy_devoirs'           => $notes[$i]->moy_devoirs,
                 'examen'                => $notes[$i]->examen,
                 'matiere'               => $notes[$i]->matiere,
                
                 
             ];
            
          
            
             array_push($data,$obj);
        }
  
    return response()->json(
        $data
        ,200);
    }
    public function bulletins_tuteur($id)
    {   
        $notes = Note::where('eleve_id', $id)->select(DB::raw('DISTINCT trimestre, annee_scolaire'))
             ->get();
      
        return response()->json(
            $notes
            ,200);
    }
    public function bulletins_eleve()
    {   $elv=Eleve::where('user_id',Auth::user()->id)->first();
       
        $notes = Note::where('eleve_id', $elv->id)->select(DB::raw('DISTINCT trimestre, annee_scolaire'))
             ->get();
      
        return response()->json(
            $notes
            ,200);
    }

    public function index_tuteur($id, $trimestre, $annee)
    {  
        $data=[];
        $notes = DB::table('notes')
            ->where('eleve_id', $id)
            ->where('trimestre', $trimestre)
            ->where('annee_scolaire', $annee)
            ->get();
            for($i = 0; $i <  count($notes); $i++){
              
                 $obj=[
                     'id'                    => $notes[$i]->id,
                     'cc'                    => $notes[$i]->cc,
                     'tp'                    => $notes[$i]->TP,
                     'moy_devoirs'           => $notes[$i]->moy_devoirs,
                     'examen'                => $notes[$i]->examen,
                     'matiere'               => $notes[$i]->matiere,
                    
                     
                 ];
                
              
                
                 array_push($data,$obj);
            }
      
        return response()->json(
            $data
            ,200);
    }
}
