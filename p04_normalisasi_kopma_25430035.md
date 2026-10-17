* Dari UNF ke 1NF



1\. Tulis relasi spreadsheet lama dalam bentuk UNF. Satu nota menyimpan grup berulang barang:

NOTA\_UNF (no\_nota\_penjualan, tgl\_penjualan, kode\_petugas, nama\_petugas, no\_anggota, nama\_anggota,

{ kode\_barang, nama\_barang, qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan, subtotal\_detail\_penjualan },

jumlah\_penjualan, diskon\_penjualan, total\_penjualan)



2\. Hilangkan grup berulang: satu baris untuk setiap barang di setiap nota. Kunci primer menjadi komposit (no\_nota\_penjualan, kode\_barang).

NOTA\_1NF (no\_nota\_penjualan, kode\_barang, tgl\_penjualan, kode\_petugas, nama\_petugas, no\_anggota,

nama\_anggota, nama\_barang, qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan, subtotal\_detail\_penjualan, jumlah\_penjualan, diskon\_penjualan, total\_penjualan)



* Menuliskan Dependensi Fungsional



3\. Turunkan dependensi fungsional dari aturan bisnis Pertemuan 2, bukan dari isi spreadsheet.

FD1: no\_nota\_penjualan -> tgl\_penjualan, kode\_petugas, no\_anggota (AB-01)

FD2: kode\_petugas -> nama\_petugas

FD3: no\_anggota -> nama\_anggota (AB-05)

FD4: kode\_barang -> nama\_barang

FD5: (no\_nota\_penjualan, kode\_barang)

\-> qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan (AB-04)

FD6: qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan

\-> subtotal\_detail\_penjualan (turunan)



* Menuju 2NF dan 3NF



4\. 2NF. FD1 dan FD4 hanya bergantung pada sebagian kunci komposit. Pisahkan menjadi relasi sendiri: penjualan (kunci no\_nota\_penjualan) dan barang (kunci kode\_barang). Sisanya menjadi detail penjualan.



5\. 3NF. Di relasi penjualan terdapat rantai no\_nota\_penjualan → kode\_petugas → nama\_petugas dan no\_nota\_penjualan → no\_anggota → nama\_anggota. Pisahkan petugas dan anggota menjadi relasi sendiri.



6\. Nilai turunan. subtotal\_detail\_penjualan, jumlah\_penjualan, dan total\_penjualan dapat dihitung dari detail dan status anggota. Buku ini memutuskan tidak menyimpannya di tabel operasional, sehingga tidak mungkin tidak konsisten.



PENJUALAN (no\_nota\_penjualan, tgl\_penjualan, kode\_petugas\*,

&#x20;          no\_anggota\*, bayar\_penjualan)

DETAIL\_PENJUALAN (no\_nota\_penjualan\*, kode\_barang\*,

&#x20;                 qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan)

BARANG (kode\_barang, nama\_barang, kategori\_barang, harga\_jual\_barang,

&#x20;       stok\_barang, stok\_min\_barang)

PETUGAS (kode\_petugas, nama\_petugas, peran\_petugas)

ANGGOTA (no\_anggota, nim\_anggota, nama\_anggota, prodi\_anggota,

&#x20;        no\_hp\_anggota, status\_anggota, tgl\_daftar\_anggota)

\-- garis bawah = kunci primer, \* = kunci tamu



* Keputusan Nilai Turunan



|Atribut|Keputusan|Alasan|
|-|-|-|
|subtotal\_detail\_penjualan|Tidak disimpan|Dapat dihitung dari kuantitas dikalikan harga satuan transaksi.|
|jumlah\_penjualan|Tidak disimpan|Dapat dihitung dari penjumlahan subtotal detail penjualan.|
|total\_penjualan|Tidak disimpan pada tabel operasional|Dapat dihitung dari jumlah penjualan dan diskon sesuai aturan perhitungan.|
|harga\_satuan\_detail\_penjualan|Disimpan|Mencatat harga pada saat transaksi agar riwayat penjualan tidak berubah ketika harga barang diperbarui.|



* Mencocokkan dengan Skema Kanonik



7\. Tabel kunci primer, kunci unik, dan kunci tamu



|Tabel|Kunci primer|Kunci unik|Kunci tamu|
|-|-|-|-|
|petugas|id\_petugas|kode\_petugas	|–|
|anggota|id\_anggota	|no\_anggota, nim\_anggota	|–|
|barang|id\_barang|kode\_barang	|–|
|pemasok|id\_pemasok|–	|–|
|penjualan|id\_penjualan	|no\_nota\_penjualan|id\_petugas, id\_anggota (boleh NULL)|
|detail\_penjualan|(id\_penjualan, id\_barang)|–	|id\_penjualan, id\_barang|
|pembelian|id\_pembelian|–|id\_pemasok|
|detail\_pembelian|(id\_pembelian, id\_barang)|–	|id\_pembelian, id\_barang|



8\. Pemeriksaan BCNF



Setiap determinan pada dependensi fungsional nontrivial harus merupakan kunci kandidat. Contohnya, kode\_barang menentukan nama\_barang, sehingga kode\_barang harus unik pada tabel barang. Pada tabel detail, gabungan kunci menentukan kuantitas dan harga transaksi. Jika ditemukan determinan yang bukan kunci kandidat, relasi tersebut perlu diperiksa kembali.

