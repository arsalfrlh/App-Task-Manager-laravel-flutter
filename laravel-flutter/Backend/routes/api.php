<?php

use App\Http\Controllers\AuthApiController;
use App\Http\Controllers\TaskApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->group(function(){
    Route::get('/tugas',[TaskApiController::class,'index']);
    Route::post('/tugas/tambah',[TaskApiController::class,'create']);
    Route::post('/tugas/edit',[TaskApiController::class,'edit']);
    Route::put('/tugas/update',[TaskApiController::class,'update']);
    Route::put('/tugas/update/status',[TaskApiController::class,'updateStatus']);
    Route::delete('/tugas/hapus/{id}',[TaskApiController::class,'destroy']);
    Route::post('/logout',[AuthApiController::class,'logout']);
    Route::get('/tugas/selesai/{id}',[TaskApiController::class,'taskDone']);
    Route::post('/tugas/search',[TaskApiController::class,'search']);
    Route::post('/send/data',[AuthApiController::class,'sendData']);
});

Route::post('/login',[AuthApiController::class,'login']);
Route::post('/register',[AuthApiController::class,'register']);
