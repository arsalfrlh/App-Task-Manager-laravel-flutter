<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TaskApiController extends Controller
{
    public function index(){
        $data = Task::with('user')->get();
        return response()->json(['message' => 'menampilkan semua Tugas', 'success' => true, 'data' => $data]);
    }

    public function taskDone($id){
        $data = Task::with('user')->where('id_user', $id)->get();
        return response()->json(['message' => 'menampilkan tugas selesai', 'success' => true, 'data' => $data]);
    }

    public function search(Request $request){
        $cari = $request->search;
        if(strlen($cari)){
            $data = Task::with('user')->where('title','like',"%$cari%")->orWhere('deskripsi','like',"%$cari%")->get();
        }else{
            $data = null;
        }

        return response()->json(['message' => 'Mencari data Tugas', 'success' => true, 'data' => $data]);
    }

    public function create(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'required|image|mimes:jpg,jpeg,png|max:2048',
            'title' => 'required',
            'deskripsi' => 'required',
            'status' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()->all()]);
        }

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $gambar = null;
        }

        $data = Task::create([
            'gambar' => $nmgambar,
            'title' => $request->title,
            'deskripsi' => $request->deskripsi,
            'status' => $request->status,
        ]);

        return response()->json(['message' => 'Berhasil menambahkan Tugas baru', 'success' => true, 'data' => $data]);
    }

    public function edit(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'image|mimes:jpg,jpeg,png|max:2048',
            'title' => 'required',
            'deskripsi' => 'required',
            'status' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()->all()]);
        }

        $task = Task::where('id',$request->id)->first();
        if($request->hasFile('gambar')){
            if($task->gambar && file_exists(public_path('images/'.$task->gambar))){
                unlink(public_path('images/'.$task->gambar));
            }

            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = $task->gambar;
        }

        $data = Task::where('id',$request->id)->update([
            'gambar' => $nmgambar,
            'title' => $request->title,
            'deskripsi' => $request->deskripsi,
            'status' => $request->status,
        ]);

        return response()->json(['message' => 'Task berhasil di update', 'success' => true, 'data' => $data]);
    }

    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'id' => 'required',
            'title' => 'required',
            'deskripsi' => 'required',
            'status' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $data = Task::where('id', $request->id)->update([
            'title' => $request->title,
            'deskripsi' => $request->deskripsi,
            'status' => $request->status,
        ]);

        return response()->json(['message' => 'Update Tugas berhasil', 'success' => true, 'data' => $data]);
    }

    public function updateStatus(Request $request){
        $validator = Validator::make($request->all(),[
            'id' => 'required',
            'status' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        if($request->status == 'selesai'){
            $id_user = $request->id_user;
        }else{
            $id_user = null;
        }

        $data = Task::where('id', $request->id)->update([
            'id_user' => $id_user,
            'status' => $request->status,
        ]);

        return response()->json(['message' => 'Tugas berhasil diperbaharui', 'success' => true, 'data' => $data]);
    }

    public function destroy($id){
        $task = Task::where('id',$id)->first();
        if($task->gambar && file_exists(public_path('images/'.$task->gambar))){
            unlink(public_path('images/'.$task->gambar));
        }

        $data = Task::where('id',$id)->delete();
        return response()->json(['message' => 'Tugas telah di hapus', 'success' => true, 'data' => $data]);
    }
}
