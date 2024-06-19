<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Support extends Model
{
    use HasFactory;
    protected $fillable = [
        'titre',
        'contenu',
        'file_path',
        'file_name',
        'enseignant_id',
        'room_id',
    ];
}
