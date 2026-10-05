\# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (fiktif)



\## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat A-xxxx. Anggota aktif memperoleh diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok; bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Kutipan wawancara. Ketua: “Harga barang sering naik, jadi kami bingung saat melihat nota lama.” Petugas gudang: “Kadang di buku catatan stoknya malah minus.” Kasir: “Anggota sering lupa membawa kartu, jadi kami mencarinya lewat NIM.”



\## 2. Aktor dan proses bisnis

|Kode|Proses bisnis|Aktor|Pemicu|
|-|-|-|-|
|PB-01|Mendaftarkan anggota|Kasir (atas permintaan mahasiswa)|Kasir (atas permintaan mahasiswa)|
|PB-02|Mencatat penjualan|Kasir|Pembeli membayar di kasir|
|PB-03|Memesan barang ke pemasok|Petugas gudang|Stok di bawah batas minimum|
|PB-04|Menerima barang dari pemasok|Petugas gudang|Barang datang bersama faktur|
|PB-05|Menyusun laporan bulanan|Ketua koperasi|Awal bulan|



\## 3. Dokumen sumber yang dianalisis

!\[screenshot percobaan](screenshot/Percobaan\_Gambar.png)



\## 4. Entitas kandidat dan elemen data

|Entitas kandidat|Elemen data utama|Sumber|
|-|-|-|
|Anggota|nomor anggota, NIM, nama, program studi, nomor HP, status aktif, poin loyalitas|Formulir pendaftaran|
|Barang|kode, nama, kategori, harga jual, stok, batas minimum stok|Daftar barang, faktur|
|Penjualan|nomor nota, tanggal-jam, kasir, anggota (opsional), bayar|Nota penjualan|
|Detail penjualan|nomor nota, barang, qty, harga saat transaksi|Nota penjualan|
|Petugas|kode petugas, nama, peran (kasir/gudang/ketua)|Wawancara|
|Pemasok|kode, nama, telepon, alamat|Faktur pemasok|
|Pembelian dan detailnya|nomor faktur, tanggal, pemasok, barang, qty, harga beli|Faktur pemasok|



\## 5. Aturan bisnis

|Kode|Aturan Bisnis|
|-|-|
|AB-01|Setiap nota memiliki nomor unik dan minimal satu baris barang.|
|AB-02|Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%.|
|AB-03|Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.|
|AB-04|Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.|
|AB-05|NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.|
|AB-06|Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.|
|AB-07|Setiap kelipatan Rp10.000 dari belanja anggota mendapatkan 1 poin loyalitas|
|AB-08|Setiap 50 poin loyalitas dapat ditukar dengan diskon Rp5.000|



\## 6. Kebutuhan informasi

|Kode|Kebutuhan informasi|Data yang diperlukan|
|-|-|-|
|KI-01|Omzet dan jumlah nota per hari dan per bulan|Penjualan, detail penjualan|
|KI-02|Lima barang terlaris per bulan berdasarkan qty|Detail penjualan, barang|
|KI-03|Barang dengan stok di bawah batas minimum|Barang|
|KI-04|Sepuluh anggota dengan belanja terbesar per bulan|Penjualan, detail penjualan, anggota|
|KI-05|Jumlah poin loyalitas setiap anggota|Anggota, penjualan, detail penjualan|
|KI-06|Daftar anggota yang memiliki minimal 50 poin loyalitas|Anggota|



\## 7. Matriks CRUD

|Proses|Anggota|Barang|Penjualan|Detail|Pemasok|Pembelian|
|-|-|-|-|-|-|-|
|PB-01 Daftar anggota|C||||||
|PB-02 Catat penjualan|R,U|R,U|C|C|||
|PB-03 Pesan ke pemasok||R|||R|C|
|PB-04 Terima barang||U|||R|U|
|PB-05 Laporan bulanan|R|R|R|R||R|



\## 8. Kamus data awal

|Elemen|Arti|Contoh|Aturan|Penanggung jawab|
|-|-|-|-|-|
|no\_anggota|Nomor anggota koperasi|A-0457|Unik, format A-4 digit|Ketua|
|nim\_anggota|NIM anggota|2301010123|Unik, 10 digit|Ketua|
|no\_hp\_anggota<br />|<br />Nomor HP anggota<br />|<br />0812xxxx<br />|Data pribadi, akses terbatas|Ketua|
|no\_nota\_penjualan|<br />Nomor nota penjualan<br />|PJ-2609-0142|Unik per nota|Kasir|
|harga\_satuan\_detail\_penjualan|<br />Harga jual saat transaksi<br />|4000|Bilangan bulat ≥ 0 (rupiah)|Kasir|
|stok\_barang|Jumlah barang tersedia|35|Bilangan bulat ≥ 0 (AB-03)|Petugas gudang|





\## 9. Kebutuhan non-fungsional data

Kebutuhan non-fungsional dicatat singkat: perkiraan ±150 nota per hari, data transaksi disimpan minimal lima tahun, dan nomor HP anggota hanya boleh dilihat oleh ketua. Pembatasan akses data pribadi seperti ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi \[17].



\## 10. Isu kualitas data yang diantisipasi

Data anggota dapat tercatat lebih dari satu kali jika pencarian berdasarkan NIM tidak benar. Selain itu, stok barang menjadi tidak sesuai apabila pencatatan penjualan dan penerimaan barang tidak diperbarui. Harga barang tetap perlu disimpan agar saat adanya transaksi data lama tetap sesuai meski harga barangnya berubah.

