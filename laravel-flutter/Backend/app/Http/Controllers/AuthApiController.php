<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Sanctum\PersonalAccessToken;

class AuthApiController extends Controller
{
    public function login(Request $request){
        $validator = Validator::make($request->all(),[
            'email' => 'email|required',
            'password' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($login)){
            $data = [
                'token' => Auth::user()->createToken('auth-token')->plainTextToken,
                'name' => Auth::user()->name,
                'level' => Auth::user()->level,
            ];
            return response()->json(['message' => 'Login Berhasil', 'success' => true, 'data' => $data]);
        }else{
            return response()->json(['message' => 'Email atau Password anda salah', 'success' => false, 'data' => null]);
        }
    }

    public function register(Request $request){
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'email' => 'email|required|unique:users',
            'password' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'level' => 'user',
        ]);
        $data = [
            'token' => $user->createToken('auth-token')->plainTextToken,
            'name' => $user->name,
            'level' => 'user',
        ];
        return response()->json(['message' => 'Register Berhasil', 'success' => true, 'data' => $data]);
    }

    public function logout(Request $request){
        $request->user()->tokens()->delete();
        return response()->json(['message' => 'Anda telah logout']);
    }

    public function sendData(Request $request){
        $validator = Validator::make($request->all(),[
            'token' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $token = $request->token;
        if(!$token){ //jika token tidak ada
            return response()->json(['message' => 'Token tidak di temukan', 'success' => false, 'data' => null]);
        }

        $aksesToken = PersonalAccessToken::findToken($token); //mencari token di database
        if(!$aksesToken){ //jika request token ada tpi tdak ada di database
            return response()->json(['message' => 'Token tidak Valid', 'success' => false, 'data' => null]);
        }

        $user = $aksesToken->tokenable; //mengkonversi token utk mengambil data user
        $data = [
            'name' => $user->name,
            'email' => $user->email,
            'level' => $user->level,
        ];
        return response()->json(['message' => 'berhasil menampilkan data user', 'success' => true, 'data' => $data]);
    }
}
