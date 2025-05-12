<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<body>
    <div class="container">
        <div class="card" style="width: 40rem;">
        <div class="card-body">
            <h1>Edit Tugas</h1>
            @if ($errors->any())
                <div class="pt-3 alert-danger">
                    <ul>
                        @foreach ($errors->all() as $item)
                            <li>{{ $item }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif
            <form action="/tugas/update/proses" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')
                @foreach ($tampil as $task)
                <div class="form-group">
                    <img src="{{ asset('images/'.$task->gambar) }}" width="80">
                    <input type="hidden" value="{{ $task->id }}" name="id">
                    <input type="file" name="gambar" class="form-control" id="exampleInputEmail1">
                </div>
                <div class="form-group">
                    <label for="exampleInputEmail1">Title</label>
                    <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" value="{{ $task->title }}" placeholder="Judul Tugas" name="title">
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Deskripsi</label>
                    <input type="text" class="form-control" id="exampleInputPassword1" placeholder="Deskripsi" value="{{ $task->deskripsi }}" name="deskripsi">
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Status</label>
                    <select class="form-control" id="exampleInputPassword1" name="status">
                        <option value="selesai">Selesai</option>
                        <option value="belum selesai">Belum Selesai</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Update</button> <a href="/index" class="btn btn-warning">Kembali</a>
                @endforeach
            </form>
        </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @if ($pesan = Session::get('gagal'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif

    @if ($pesan = Session::get('logout'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif
</body>
</html>