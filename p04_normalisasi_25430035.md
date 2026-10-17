Modul 4: Normalisasi dan Skema Relasional



Dari UNF ke 1NF

1\. Tulis relasi awal dalam bentuk UNF. Satu resep menyimpan grup berulang obat:



RESEP\_UNF (

&#x20; id\_resep, tanggal\_resep, id\_pemeriksaan, dokter,

&#x20; {

&#x20;   id\_obat, nama\_obat, jumlah\_obat, aturan\_pemakaian

&#x20; }

)



2\. Hilangkan grup berulang: satu baris untuk setiap obat di setiap resep. Kunci primer menjadi komposit (id\_resep, id\_obat).



RESEP\_1NF (

&#x20; id\_resep, id\_obat, tanggal\_resep, id\_pemeriksaan,

&#x20; dokter, nama\_obat, jumlah\_obat, aturan\_pemakaian

)



Menuliskan Dependensi Fungsional

3\. Turunkan dependensi fungsional dari aturan bisnis proyek, bukan dari isi contoh data.



FD1: id\_pasien -> NIK, nama\_pasien, tanggal\_lahir,

&#x20;    jenis\_kelamin, alamat, no\_HP

&#x20;    (AB-01 dan aturan NIK wajib unik)

FD2: id\_kunjungan -> id\_pasien, tanggal\_kunjungan,

&#x20;    jenis\_kunjungan, keluhan

&#x20;    (AB-02)

FD3: id\_pemeriksaan -> id\_kunjungan,

&#x20;    hasil\_pemeriksaan, diagnosis

&#x20;    (AB-03)

FD4: id\_resep -> id\_pemeriksaan, tanggal\_resep, dokter

&#x20;    (AB-04, mengikuti ERD)

FD5: (id\_resep, id\_obat) -> jumlah\_obat,

&#x20;    aturan\_pemakaian

&#x20;    (AB-05)

FD6: id\_pembayaran -> id\_kunjungan,

&#x20;    tanggal\_pembayaran, total\_bayar, metode\_pembayaran

&#x20;    (AB-07)

FD7: id\_obat -> nama\_obat, satuan, harga\_obat, stok\_obat

FD8: id\_pemasok -> nama\_pemasok, alamat, no\_HP

FD9: id\_penerimaan -> id\_pemasok, tanggal\_penerimaan

FD10: (id\_penerimaan, id\_obat) -> jumlah\_diterima

FD11: NIK -> id\_pasien, nama\_pasien, tanggal\_lahir,

&#x20;     jenis\_kelamin, alamat, no\_HP

&#x20;     (aturan bisnis NIK wajib dan unik)



Menuju 2NF dan 3NF

4\. 2NF. Pada relasi RESEP\_1NF, kunci komposit terdiri dari id\_resep dan id\_obat. Atribut tanggal\_resep, id\_pemeriksaan, dan dokter hanya bergantung pada id\_resep, sedangkan nama\_obat bergantung pada id\_obat. Pisahkan menjadi relasi resep dan obat. Atribut jumlah\_obat dan aturan\_pemakaian tetap berada pada relasi detail resep karena bergantung pada keseluruhan kunci komposit.



5\. 3NF. Atribut pemeriksaan seperti hasil\_pemeriksaan dan diagnosis bergantung pada id\_pemeriksaan, bukan langsung pada id\_resep. Karena itu, data pemeriksaan dipisahkan dalam relasi PEMERIKSAAN. Data pasien juga disimpan terpisah dalam relasi PASIEN, sedangkan data kunjungan disimpan dalam relasi KUNJUNGAN. Pemisahan ini menghindari pengulangan data pasien, kunjungan, pemeriksaan, dan obat pada tabel resep.



6\. Nilai turunan. Atribut total\_bayar dapat dihitung dari biaya yang tercatat pada transaksi, tetapi perlu dipertimbangkan untuk tetap disimpan sebagai catatan nilai pembayaran saat transaksi terjadi. Atribut stok\_obat disimpan sebagai stok terkini dan harus diperbarui secara konsisten ketika obat diterima atau dikeluarkan. Atribut jumlah\_obat dan jumlah\_diterima tetap disimpan karena merupakan fakta transaksi yang mencatat kuantitas obat pada resep dan penerimaan.



PASIEN (id\_pasien, NIK\*, nama\_pasien, tanggal\_lahir,

&#x20;       jenis\_kelamin, alamat, no\_HP)

KUNJUNGAN (id\_kunjungan, id\_pasien\*, tanggal\_kunjungan,

&#x20;          jenis\_kunjungan, keluhan)

PEMERIKSAAN (id\_pemeriksaan, id\_kunjungan\*,

&#x20;            hasil\_pemeriksaan, diagnosis)

RESEP (id\_resep, id\_pemeriksaan\*, tanggal\_resep, dokter)

DETAIL\_RESEP (id\_resep\*, id\_obat\*, jumlah\_obat,

&#x20;             aturan\_pemakaian)

OBAT (id\_obat, nama\_obat, satuan, harga\_obat, stok\_obat)

PEMBAYARAN (id\_pembayaran, id\_kunjungan\*,

&#x20;           tanggal\_pembayaran, total\_bayar, metode\_pembayaran)

PEMASOK (id\_pemasok, nama\_pemasok, alamat, no\_HP)

PENERIMAAN (id\_penerimaan, id\_pemasok\*, tanggal\_penerimaan)

DETAIL\_PENERIMAAN (id\_penerimaan\*, id\_obat\*, jumlah\_diterima)



\-- garis bawah = kunci primer; \* = kunci tamu (FK)



Catatan: Tanda \* menunjukkan FK, sedangkan penentuan PK mengikuti ERD proyek. Untuk DETAIL\_RESEP, PK gabungan adalah (id\_resep, id\_obat); untuk DETAIL\_PENERIMAAN, PK gabungan adalah (id\_penerimaan, id\_obat). NIK direncanakan sebagai NOT NULL dan UNIQUE.



Mencocokkan dengan Skema Kanonik

7\. Membandingkan dengan skema kanonik. Bandingkan hasil normalisasi dengan ERD Klinik Sehat ZI. Perbedaan utama terdapat pada penggunaan kunci pengganti (surrogate key) id\_\* sebagai kunci primer, sedangkan atribut alami seperti NIK digunakan sebagai atribut unik. Pada tabel detail resep dan detail penerimaan, kunci primer merupakan gabungan dua kunci tamu.



8\. Memeriksa PK, UNIQUE, dan FK. Pastikan setiap tabel mempunyai kunci primer, hubungan antartabel menggunakan kunci tamu yang sesuai dengan ERD, dan atribut yang harus unik memiliki batasan UNIQUE. Pada tabel PASIEN, NIK ditetapkan NOT NULL dan UNIQUE berdasarkan asumsi aturan bisnis bahwa setiap pasien memiliki NIK yang wajib diisi dan tidak boleh sama.



9\. Memeriksa BCNF. Suatu relasi memenuhi Boyce-Codd Normal Form (BCNF) apabila setiap determinan pada ketergantungan fungsional nontrivial merupakan superkey. Berdasarkan ketergantungan fungsional yang telah diidentifikasi, pemeriksaan dilakukan dengan memastikan bahwa atribut penentu seperti id\_pasien, id\_kunjungan, id\_pemeriksaan, id\_resep, id\_obat, id\_pembayaran, id\_pemasok, dan id\_penerimaan merupakan kunci pada relasi masing-masing. Pada tabel detail, gabungan kunci primer digunakan untuk menentukan atribut transaksi yang bergantung pada seluruh kunci.



|Tabel|Kunci primer|Kunci unik|Kunci Tamu|
|-|-|-|-|
|pasien|id\_pasien|NIK|-|
|kunjungan|id\_kunjungan|-|id\_pasien|
|pemeriksaan|id\_pemeriksaan|-|id\_kunjungan|
|resep|id\_resep|-|id\_pemeriksaan|
|detail\_resep|(id\_resep, id\_obat)|-|id\_resep, id\_obat|
|obat|id\_obat|-|-|
|pembayaran|id\_pembayaran|-|id\_kunjungan|
|pemasok|id\_pemasok|-|-|
|penerimaan|id\_penerimaan|-|id\_pemasok|
|detail\_penerimaan|(id\_penerimaan, id\_obat)|-|id\_penerimaan, id\_obat|



Keputusan Penyimpanan Nilai Turunan



|Atribut|Keputusan|Alasan|
|-|-|-|
|total\_bayar|Disimpan|Menjadi catatan nominal pembayaran saat transaksi dilakukan. Nilainya harus konsisten dengan perhitungan biaya transaksi.|
|stok\_obat|Disimpan|Dibutuhkan untuk mengetahui stok terkini dengan cepat. Nilainya harus diperbarui secara konsisten setiap ada penerimaan atau pengeluaran obat.|
|jumlah\_obat|Disimpan|Merupakan jumlah obat yang diresepkan pada suatu transaksi, bukan nilai yang dihitung dari atribut lain.|
|jumlah\_diterima|Disimpan|Mencatat jumlah obat yang diterima dari pemasok pada suatu transaksi penerimaan.|
|subtotal\_detail\_resep|Tidak disimpan|Jika subtotal dihitung dari jumlah\_obat × harga\_obat, nilainya dapat dihitung saat diperlukan.|
|total\_bayar hasil penjumlahan rincian biaya|Tidak perlu disimpan sebagai hasil hitung terpisah|Jika hanya berupa hasil penjumlahan rincian biaya, nilai tersebut dapat dihitung dari rincian transaksi. Namun, nominal pembayaran aktual tetap dapat disimpan sebagai catatan transaksi.|



ERD Klinik Sehat ZI

!\[Screenshot ERD Klinik](screenshot/p04\_erd\_25430035.png)



Catatan Perubahan ERD



1. Atribut NIK pada tabel pasien ditetapkan sebagai UNIQUE dan NOT NULL berdasarkan asumsi bahwa setiap pasien wajib memiliki NIK yang berbeda.
2. Tabel detail\_resep menggunakan kunci primer gabungan (id\_resep, id\_obat).
3. Tabel detail\_penerimaan menggunakan kunci primer gabungan (id\_penerimaan, id\_obat).
4. Hubungan antartabel tetap mengikuti ERD proyek Klinik Sehat ZI.



Kesimpulan



Proses normalisasi dilakukan mulai dari bentuk tidak normal (UNF), bentuk normal pertama (1NF), bentuk normal kedua (2NF), hingga bentuk normal ketiga (3NF). Hasilnya berupa tabel-tabel yang memisahkan data pasien, kunjungan, pemeriksaan, resep, obat, pembayaran, pemasok, dan penerimaan obat. Pemisahan ini membantu mengurangi pengulangan data serta menjaga konsistensi hubungan antartabel. Pemeriksaan BCNF dilakukan berdasarkan ketergantungan fungsional dan kunci pada setiap relasi.

