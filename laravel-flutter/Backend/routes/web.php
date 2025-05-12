<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TaskController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/login',[AuthController::class,'login']);
Route::post('/login/proses',[AuthController::class,'loginProses']);
Route::get('/register',[AuthController::class,'register']);
Route::post('/register/proses',[AuthController::class,'registerProses']);

Route::get('/logout',[AuthController::class,'logout']);
Route::get('/index',[TaskController::class,'index']);
Route::get('/tugas/tambah',[TaskController::class,'create']);
Route::post('/tugas/tambah/proses',[TaskController::class,'store']);
Route::get('/tugas/edit/{id}',[TaskController::class,'edit']);
Route::put('/tugas/update/proses',[TaskController::class,'update']);
Route::delete('/tugas/haspus/{id}',[TaskController::class,'destroy']);
Route::put('/tugas/update/status',[TaskController::class,'updateStatus']);
