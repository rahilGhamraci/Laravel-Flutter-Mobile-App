<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Edt extends Model
{
    use HasFactory;
    protected $fillable = [
        'trimestre',
        'annee_scolaire',
        'file_path',
        'file_name',
        'classe_id',
    ];
}
