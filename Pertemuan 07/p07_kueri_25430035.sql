-- =====================================================================
-- p07_kueri_25430035.sql
-- Milestone Proyek 7 : kueri satu tabel untuk kebutuhan informasi (KI), proyek Klinik Sehat ZI
-- DBMS               : MariaDB 10.4.32 (XAMPP 8.2.12), basis data klinik_035
--
-- ISI       : 13 kueri satu tabel, mengikuti Langkah D.1 sampai D.3 Modul 7.
-- KOMENTAR  : setiap kueri memuat (1) kode KI, (2) pertanyaan sehari-hari,
--             (3) hasil yang diharapkan sebelum dijalankan.
-- KI        : p02_kebutuhan_data_25430035.md bagian 6.
--             KI-01 jumlah pasien terdaftar dan kunjungan per hari/bulan
--             KI-02 riwayat pemeriksaan pasien pada rentang waktu
--             KI-03 daftar resep dan obat yang diberikan kepada pasien
--             KI-04 daftar obat dengan stok di bawah batas minimum
--             KI-05 jumlah dan total pembayaran per hari/bulan
--             KI-06 daftar pasien yang berkunjung pada rentang waktu
--
-- CATATAN   : tabel obat belum memiliki kolom batas minimum. Untuk KI-04,
--             batas minimum ditulis sebagai angka 100 pada kueri (pengganti
--             sementara). Lihat bagian akhir berkas.
-- =====================================================================

USE klinik_035;

-- ---------------------------------------------------------------------
-- D.1 Proyeksi dan penyaringan
-- ---------------------------------------------------------------------

-- [Q01] KI-04
-- Pertanyaan: Obat apa saja yang stoknya di bawah 100, dan berapa kurangnya
--             dari batas itu? Urutkan dari yang paling kurang.
-- Hasil yang diharapkan: 2 baris.
--   1. Amoxicillin 500 mg (kapsul), stok 30, kurang 70
--   2. Paracetamol 500 mg (tablet), stok 40, kurang 60
SELECT nama_obat, satuan, stok_obat, 100 - stok_obat AS kurang
FROM obat
WHERE stok_obat < 100
ORDER BY kurang DESC;

-- [Q02] KI-01
-- Pertanyaan: Lima kunjungan terbaru yang jenisnya Rawat Jalan atau Kontrol ulang
--             itu yang mana saja?
-- Hasil yang diharapkan: 5 baris, diurutkan dari tanggal terbaru lalu nomor kunjungan
--   terbesar (tiga baris tanggal 2025-05-02, dua baris tanggal 2025-04-30):
--   1. KJ-0090-2025, Rawat Jalan, 2025-05-02
--   2. KJ-0089-2025, Rawat Jalan, 2025-05-02
--   3. KJ-0088-2025, Rawat Jalan, 2025-05-02
--   4. KJ-0085-2025, Rawat Jalan, 2025-04-30
--   5. KJ-0084-2025, Rawat Jalan, 2025-04-30
SELECT no_kunjungan, jenis_kunjungan, tanggal_kunjungan
FROM kunjungan
WHERE jenis_kunjungan IN ('Rawat Jalan', 'Kontrol ulang')
ORDER BY tanggal_kunjungan DESC, no_kunjungan DESC
LIMIT 5;

-- [Q03] KI-06 (bagian satu tabel; nama pasien perlu JOIN, lihat akhir berkas)
-- Pertanyaan: Kunjungan apa saja yang terjadi dari 10 sampai 12 April 2025?
-- Hasil yang diharapkan: 15 baris, KJ-0001-2025 sampai KJ-0015-2025,
--   tanggal 2025-04-10, 2025-04-11, dan 2025-04-12 masing-masing 5 baris.
SELECT no_kunjungan, id_pasien, tanggal_kunjungan, jenis_kunjungan
FROM kunjungan
WHERE tanggal_kunjungan BETWEEN '2025-04-10' AND '2025-04-12'
ORDER BY tanggal_kunjungan, no_kunjungan;

-- [Q04] KI-01 (kualitas data pasien, p02 bagian 10)
-- Pertanyaan: Adakah pasien yang belum punya alamat atau nomor HP?
-- Hasil yang diharapkan: 0 baris, karena kelima pasien pada data Pertemuan 6
--   memiliki alamat dan nomor HP. Hasil kosong di sini benar, bukan galat.
SELECT no_pasien, nama_pasien, alamat, no_HP
FROM pasien
WHERE alamat IS NULL OR no_HP IS NULL;

-- [Q05] KI-01
-- Pertanyaan: Jenis kunjungan apa saja yang ada di klinik?
-- Hasil yang diharapkan: 3 baris, urut abjad: Kontrol ulang, Pemeriksaan umum,
--   Rawat Jalan.
SELECT DISTINCT jenis_kunjungan
FROM kunjungan
ORDER BY jenis_kunjungan;

-- ---------------------------------------------------------------------
-- D.2 Pola teks dan nilai kosong
-- ---------------------------------------------------------------------

-- [Q06] KI-01
-- Pertanyaan: Tampilkan pasien yang namanya mengandung huruf "a" dengan label
--             "nama (nomor pasien)", tanggal lahir format hari-bulan-tahun,
--             nomor HP (diganti "-" bila kosong), dan keterangan jenis kelamin.
--             Urutkan dari yang paling muda, ambil 5.
-- Hasil yang diharapkan: 5 baris (kelima pasien bernama mengandung "a"):
--   1. Rizky Ramadhan (P-0005-2025), 27-05-2001, 085277712345, Laki-laki
--   2. Dewi Lestari (P-0004-2025),  03-11-1992, 082144403311, Perempuan
--   3. Siti Rahma (P-0002-2025),    22-03-1988, 081298765432, Perempuan
--   4. Andi Pratama (P-0001-2025),  10-01-1985, 081234567890, Laki-laki
--   5. Budi Hartono (P-0003-2025),  15-07-1979, 081355501122, Laki-laki
SELECT CONCAT(nama_pasien, ' (', no_pasien, ')')           AS pasien,
       DATE_FORMAT(tanggal_lahir, '%d-%m-%Y')               AS tgl_lahir,
       IFNULL(no_HP, '-')                                   AS hp,
       CASE jenis_kelamin WHEN 'L' THEN 'Laki-laki'
                          ELSE 'Perempuan' END              AS keterangan
FROM pasien
WHERE nama_pasien LIKE '%a%'
ORDER BY tanggal_lahir DESC
LIMIT 5;

-- [Q07] KI-02 (bagian satu tabel; nama pasien perlu JOIN, lihat akhir berkas)
-- Pertanyaan: Pemeriksaan mana saja yang diagnosisnya berkaitan dengan alergi?
--             Tampilkan diagnosis dalam huruf kapital, ambil 10 pertama.
-- Hasil yang diharapkan: 10 baris (dari total 16 pemeriksaan bertema alergi),
--   berupa RINITIS ALERGI atau DERMATITIS ALERGI. Baris pertama: pemeriksaan 4,
--   kunjungan 4, RINITIS ALERGI. Baris keenam: pemeriksaan 27, DERMATITIS ALERGI.
SELECT id_pemeriksaan, id_kunjungan, UPPER(diagnosis) AS diagnosis
FROM pemeriksaan
WHERE diagnosis LIKE '%alergi%'
ORDER BY id_pemeriksaan
LIMIT 10;

-- [Q08] KI-03 (bagian satu tabel; nama pasien dan obatnya perlu JOIN)
-- Pertanyaan: Resep apa saja yang ditulis dokter yang namanya diawali "dr. Budi"
--             pada 10 sampai 16 April 2025? Tampilkan lima nomor resep pertama.
-- Hasil yang diharapkan: 5 baris (dari total 12 resep dr. Budi pada rentang itu):
--   1. R-0001-2025, 2025-04-10
--   2. R-0002-2025, 2025-04-10
--   3. R-0005-2025, 2025-04-10
--   4. R-0006-2025, 2025-04-11
--   5. R-0009-2025, 2025-04-11
SELECT no_resep, tanggal_resep, dokter
FROM resep
WHERE dokter LIKE 'dr. Budi%'
  AND tanggal_resep BETWEEN '2025-04-10' AND '2025-04-16'
ORDER BY no_resep
LIMIT 5;

-- [Q09] KI-05 (bagian satu tabel; jumlah dan total per hari perlu fungsi agregat)
-- Pertanyaan: Lima pembayaran pertama yang memakai QRIS atau transfer itu
--             termasuk kategori besar, sedang, atau kecil?
--             Besar: 70000 ke atas; sedang: 55000 sampai 69999; kecil: di bawah 55000.
-- Hasil yang diharapkan: 5 baris, diurutkan dari id pembayaran terkecil:
--   1. id 1, 2025-04-10, 70000, transfer, Besar
--   2. id 3, 2025-04-10, 54000, transfer, Kecil
--   3. id 4, 2025-04-10, 54000, QRIS, Kecil
--   4. id 6, 2025-04-11, 65000, QRIS, Sedang
--   5. id 8, 2025-04-11, 30000, QRIS, Kecil
SELECT id_pembayaran, tanggal_pembayaran, total_bayar, metode_pembayaran,
       CASE WHEN total_bayar >= 70000 THEN 'Besar'
            WHEN total_bayar >= 55000 THEN 'Sedang'
            ELSE 'Kecil' END AS kategori
FROM pembayaran
WHERE metode_pembayaran IN ('QRIS', 'transfer')
ORDER BY id_pembayaran
LIMIT 5;

-- ---------------------------------------------------------------------
-- D.3 Tanggal dan perhitungan per baris
-- ---------------------------------------------------------------------

-- [Q10] KI-01
-- Pertanyaan: Untuk tiga kunjungan (KJ-0001, KJ-0046, KJ-0090), sudah berapa hari
--             sejak kunjungan itu sampai 2 Mei 2025, dan termasuk "baru"
--             (kurang dari 14 hari) atau "lama"?
-- Hasil yang diharapkan: 3 baris, urut tanggal:
--   1. KJ-0001-2025, 2025-04-10, 22 hari, lama
--   2. KJ-0046-2025, 2025-04-22, 10 hari, baru
--   3. KJ-0090-2025, 2025-05-02,  0 hari, baru
SELECT no_kunjungan, tanggal_kunjungan,
       DATEDIFF('2025-05-02', tanggal_kunjungan) AS hari_lalu,
       CASE WHEN DATEDIFF('2025-05-02', tanggal_kunjungan) < 14
            THEN 'baru' ELSE 'lama' END AS kategori
FROM kunjungan
WHERE no_kunjungan IN ('KJ-0001-2025', 'KJ-0046-2025', 'KJ-0090-2025')
ORDER BY tanggal_kunjungan;

-- [Q11] KI-05 (bagian satu tabel; jumlah dan total per bulan perlu fungsi agregat)
-- Pertanyaan: Pembayaran apa saja yang terjadi pada bulan Mei 2025?
-- Hasil yang diharapkan: 5 baris (semua tanggal 02-05-2025), id pembayaran 86 sampai 90:
--   86 = 52000, 87 = 56000, 88 = 51600, 89 = 72500, 90 = 72500
SELECT id_pembayaran,
       DATE_FORMAT(tanggal_pembayaran, '%d-%m-%Y') AS tanggal,
       total_bayar
FROM pembayaran
WHERE MONTH(tanggal_pembayaran) = 5 AND YEAR(tanggal_pembayaran) = 2025
ORDER BY id_pembayaran;

-- [Q12] KI-03 (bagian satu tabel; nama obat dan subtotal perlu JOIN)
-- Pertanyaan: Obat apa saja (menurut nomor obat) pada resep R-0001-2025 beserta
--             jumlah dan aturan pakainya? Setelah data dimuat, resep ini punya id 1.
-- Hasil yang diharapkan: 2 baris:
--   1. id_obat 1, jumlah 10, "3 x 1 tablet, diminum setelah makan"
--   2. id_obat 2, jumlah 10, "3 x 1 kapsul, diminum 3 kali sehari setelah makan"
SELECT id_resep, id_obat, jumlah_obat, aturan_pemakaian
FROM detail_resep
WHERE id_resep = 1
ORDER BY id_obat;

-- [Q13] KI-04 (tampilan untuk laporan, Latihan E.1)
-- Pertanyaan: Tampilkan nama obat dalam huruf kapital dan harga dalam format
--             "Rp1.500", dari yang termahal.
-- Hasil yang diharapkan: 5 baris:
--   1. AMOXICILLIN 500 MG, Rp1.500
--   2. IBUPROFEN 400 MG,   Rp1.000
--   3. CETIRIZINE 10 MG,   Rp800
--   4. PARACETAMOL 500 MG, Rp500
--   5. ANTASIDA DOEN,      Rp400
SELECT UPPER(nama_obat) AS nama,
       CONCAT('Rp', FORMAT(harga_obat, 0, 'id_ID')) AS harga
FROM obat
ORDER BY harga_obat DESC;

-- ---------------------------------------------------------------------
-- Cakupan fungsi dan operator
--   LIKE        : Q06, Q07, Q08          BETWEEN : Q03, Q08
--   IN          : Q02, Q09, Q10          IS NULL : Q04
--   CASE        : Q06, Q09, Q10          Tanggal : DATE_FORMAT (Q06, Q11),
--                                                  DATEDIFF (Q10), MONTH/YEAR (Q11)
--   String      : CONCAT (Q06, Q13), UPPER (Q07, Q13)
--   Lain        : DISTINCT (Q05), IFNULL (Q06), FORMAT (Q13), ORDER BY, LIMIT
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- KI yang belum dapat dijawab dengan satu tabel
-- (akan dijawab pada Pertemuan 9 sampai 12)
-- ---------------------------------------------------------------------
-- KI-01 bagian jumlah pasien dan jumlah kunjungan per hari/bulan
--       -> butuh COUNT dan GROUP BY (Pertemuan 9, Modul 9).
-- KI-02 riwayat pemeriksaan per pasien pada rentang waktu
--       -> butuh JOIN pasien, kunjungan, pemeriksaan (Pertemuan 10, Modul 10).
-- KI-03 daftar resep dan obat yang diberikan kepada pasien
--       -> butuh JOIN pasien, kunjungan, pemeriksaan, resep, detail_resep, obat
--          (Pertemuan 10); subtotal per resep memakai harga obat dan SUM (Pertemuan 9).
-- KI-05 jumlah dan total pembayaran per hari dan per bulan
--       -> butuh COUNT/SUM dengan GROUP BY (Pertemuan 9), dan JOIN dengan kunjungan
--          bila ditampilkan per pasien (Pertemuan 10).
-- KI-06 daftar pasien (nama) yang berkunjung pada rentang waktu
--       -> butuh JOIN pasien dan kunjungan (Pertemuan 10); Q03 baru menampilkan
--          id_pasien.
-- KI-04 dapat dijawab dengan satu tabel, tetapi tabel obat belum memiliki kolom
--       batas minimum stok (berbeda dengan kolom stok_min_barang pada Kopma).
--       Q01 memakai angka 100 sebagai pengganti. Keputusan menambah kolom
--       batas minimum dicatat untuk pembahasan di Pertemuan 8 atau 15.

