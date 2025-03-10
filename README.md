# MovieApp

Aplikasi ini menyediakan informasi tentang film favorit Anda dengan memanfaatkan data dari TMDB API. Selain itu, aplikasi ini juga menawarkan berbagai fitur menarik bagi pengguna, di antaranya:

- **Integrasi akun dengan TMDB**: Pengguna dapat masuk ke aplikasi menggunakan akun TMDB mereka. Jika belum memiliki akun, pengguna dapat mendaftar melalui TMDB atau menggunakan aplikasi sebagai tamu dengan fitur terbatas.

- **Discover**: Jelajahi dan temukan film baru berdasarkan genre favorit Anda.

- **Search**: Cari film kesukaan Anda dengan mudah.

- **Favorites**: Simpan film favorit ke dalam daftar khusus (hanya untuk pengguna yang login).

- **Watchlist**: Kelola daftar film yang ingin Anda tonton atau sedang Anda tonton (hanya untuk pengguna yang login).

- **About Me**: Lihat informasi profil TMDB Anda (hanya untuk pengguna yang login).

Aplikasi ini memiliki dependensi pada _package-package_ berikut:

```
http
envied
build_runner
envied_generator
google_fonts
carousel_slider
url_launcher
hive
hive_flutter
```

## Esai Lesson Learned

Selama proses pembuatan aplikasi ini, saya mempelajari banyak hal baru dalam pengembangan aplikasi mobile, mulai dari keamanan API, autentikasi, hingga penyimpanan data lokal.

Salah satu hal pertama yang saya pelajari adalah pengamanan API key. Meskipun API TMDB dapat diakses secara gratis, saya tetap ingin mengamankan key agar tidak mudah diekspos. Saya mencari cara untuk melakukan ini melalui Google dan ChatGPT, serta membaca berbagai referensi. Setelah menganalisis beberapa solusi, akhirnya saya memilih Envied package serta teknik obfuscation, agar key tidak terlihat langsung dalam kode sumber.

Selain itu, saya mendalami proses autentikasi menggunakan request token dan session. Berbeda dengan login satu langkah yang biasanya saya gunakan, TMDB API memerlukan beberapa tahap: mendapatkan request token, memvalidasi request token, lalu memperoleh session token. Ini adalah pertama kalinya saya mempelajari autentikasi dengan mekanisme seperti ini, sehingga saya banyak merujuk pada API reference TMDB dan tutorial di YouTube. Salah satu tantangan menariknya adalah menghindari permintaan token yang berulang, sehingga saya bisa memanfaatkan token yang masih valid dan mengurangi request yang tidak perlu.

Selain autentikasi dan keamanan, saya juga mempelajari bagaimana memastikan tampilan tetap terupdate secara dinamis, misalnya saat menghapus film dari daftar favorit agar langsung hilang tanpa reload manual. Dalam proses ini, saya memanfaatkan ChatGPT dan dokumentasi Flutter untuk debugging serta mencari inspirasi dalam membangun widget. Saya juga menghadapi tantangan dalam mengelola struktur kode agar tetap rapi dan terorganisasi seiring bertambahnya fitur. Selain itu, saya juga mempelajari cara memanggil API lebih efisien menggunakan Uri.https, sehingga base path dan query parameter lebih rapi serta mudah dibaca.

Secara keseluruhan, proyek ini memberikan banyak pengalaman berharga dalam merancang aplikasi yang terintegrasi dengan API, mulai dari mengamankan key, menangani autentikasi, hingga mengoptimalkan pemanggilan API agar aplikasi berjalan lebih efisien dan responsif.

## Run Locally

1. Clone this git repository to your local device

```
git clone https://github.com/MHibriziF/Movie-App.git
```

2. Run `flutter pub get`from the project terminal
3. Create a new `.env` file located at the root of the project. The content of the `.env` file should look like this

```
api_key=TMDB_API_KEY
base_url=TMDB_API_BASE_URL
```

4. Run `dart run build_runner build`to generate the Env class
5. Run app with `flutter run`
