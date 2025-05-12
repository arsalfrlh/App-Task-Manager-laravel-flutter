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
        <h1>Daftar Tugas</h1> <a href="/logout" class="btn btn-danger">Logout</a>

        @if (Auth::user()->level == 'admin')
            <a href="/tugas/tambah" class="btn btn-success mb-2">tambah Tugas</a>
        @endif
        <div class="row  row-cols-1 row-cols-md-5 g-4">
        @foreach ($tampil as $task)
        <div data-aos="fade-up" data-aos-anchor-placement="top-center">
        <div class="col" style="height: 100%;">
            <div class="card" style="width: 18rem;">
            <img class="card-img-top" src="{{ asset('images/'.$task->gambar) }}" alt="Card image cap">
            <div class="card-body">
                <h5 class="card-title">{{ $task->title }}</h5>
            </div>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">{{ $task->deskripsi }}</li>
                <li class="list-group-item">Status: {{ $task->status }}</li>
            </ul>
            <div class="card-body">
                @if (Auth::user()->level == 'admin')
                    <a href="/tugas/edit/{{ $task->id }}" class="btn btn-warning">Edit</a>
                    <form action="/tugas/haspus/{{ $task->id }}" class="d-inline" method="POST">
                        @csrf
                        @method('DELETE')
                        <button type="button" class="btn btn-danger btn-delete">Hapus</button>
                    </form>
                @else
                    <form action="/tugas/update/status" method="POST" class="d-inline">
                        @csrf
                        @method('PUT')
                        <input type="hidden" value="selesai" name="status">
                        <input type="hidden" value="{{ $task->id }}" name="id">
                        <input type="submit" value="Selesai" class="btn btn-primary">
                    </form>

                    <form action="/tugas/update/status" method="POST" class="d-inline">
                        @csrf
                        @method('PUT')
                        <input type="hidden" value="belum selesai" name="status">
                        <input type="hidden" value="{{ $task->id }}" name="id">
                        <input type="submit" value="Belum Selesai" class="btn btn-warning">
                    </form>
                @endif
            </div>
            </div>
        </div>
            </div>
            @endforeach
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @if ($pesan = Session::get('login'))
        <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
        </script>
    @endif

    @if ($pesan = Session::get('tambah'))
        <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
        </script>
    @endif

    @if ($pesan = Session::get('update'))
        <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
        </script>
    @endif
    
    @if ($pesan = Session::get('hapus'))
        <script>
            Swal.fire({
            position: "center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
        </script>
    @endif

     <script type="text/javascript">
        $(function(){
            $(document).on('click', '.btn-delete', function(e){ //nama button di form hapus
                e.preventDefault();
                var form = $(this).closest('form'); // Mendapatkan form terdekat

                Swal.fire({
                    title: "Are you sure?",
                    text: "You won't be able to revert this!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit(); // Menjalankan submit form jika konfirmasi
                    }
                });
            });
        });
    </script>
</body>
</html>