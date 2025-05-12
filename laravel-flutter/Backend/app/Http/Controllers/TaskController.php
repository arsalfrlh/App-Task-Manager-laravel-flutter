<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TaskController extends Controller
{
    public function index(){
        $task = Task::with('user')->get();
        return view('main.index',['tampil' => $task]);
    }

    public function create(){
        return view('main.tambah');
    }

    public function store(Request $request){
        $request->validate([
            'gambar' => 'required|image|mimes:jpg,jpeg,png|max:2048',
            'title' => 'required',
            'deskripsi' => 'required',
            'status' => 'required',
        ]);

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        Task::create([
            'gambar' => $nmgambar,
            'title' => $request->title,
            'deskripsi' => $request->deskripsi,
            'status' => $request->status,
        ]);

        return redirect('/index')->with('tambah','Berhasil menambahkan Tugas Baru');
    }

    public function edit($id){
        $task = Task::where('id',$id)->get();
        return view('main.edit',['tampil' => $task]);
    }

    public function update(Request $request){
        $request->validate([
            'gambar' => 'image|mimes:jpg,jpeg,png|max:2048',
            'title' => 'required',
            'deskripsi' => 'required',
            'status' => 'required',
        ]);

        $task = Task::where('id',$request->id)->first();
        if($request->hasFile('gambar')){
            if($task->gambar && file_exists(public_path('images/'.$task->gambar))){
                unlink(public_path('images/'.$task->gambar));
            }

            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        Task::where('id',$request->id)->update([
            'gambar' => $nmgambar,
            'title' => $request->title,
            'deskripsi' => $request->deskripsi,
            'status' => $request->status,
        ]);

        return redirect('/index')->with('update','Tugas berhasil di Update');
    }

    public function destroy($id){
        $task = Task::where('id',$id)->first();
        if($task->gambar && file_exists(public_path('images/'.$task->gambar))){
            unlink(public_path('images/'.$task->gambar));
        }
        Task::where('id',$id)->delete();

        return redirect('/index')->with('hapus','Tugas berhasil di hapus');
    }

    public function updateStatus(Request $request){
        $request->validate([
            'status' => 'required',
        ]);

        if($request->status == 'selesai'){
            $id_user = Auth::user()->id;
        }else{
            $id_user = null;
        }

        Task::where('id',$request->id)->update([
            'id_user' => $id_user,
            'status' => $request->status,
        ]);

        return redirect('/index')->with('status','Tugas telah dikerjakan');
    }
}
