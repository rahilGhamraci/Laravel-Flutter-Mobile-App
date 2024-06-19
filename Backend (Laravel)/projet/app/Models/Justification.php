<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Justification extends Model
{
    use HasFactory;
    protected $fillable = [
        'objet',
        'text',
        'file_path',
        'file_name',
        'tuteur_id',
    ];

}
