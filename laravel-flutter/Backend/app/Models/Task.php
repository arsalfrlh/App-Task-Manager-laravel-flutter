<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $fillable = ['id_user','gambar','title','deskripsi','status'];

    public function user(){
        return $this->belongsTo(User::class,'id_user');
    }
}
