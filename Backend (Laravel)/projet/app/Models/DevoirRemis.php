<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DevoirRemis extends Model
{
    use HasFactory;
    protected $fillable = [
        'file_path',
        'file_name',
        'eleve_id',
        'devoir_id',
    ];
}
