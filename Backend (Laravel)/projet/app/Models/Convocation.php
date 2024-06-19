<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Convocation extends Model
{
    use HasFactory;
    protected $fillable = [
        'titre',
        'contenu',
        'file_path',
        'file_name',
        'room_id',
        'tuteur_id',
  
    ];
}
