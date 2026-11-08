-- ============================================
-- MODUL 7: MENJAWAB PERTANYAAN DENGAN SELECT
-- Database: kopma_035_uji
-- ============================================

-- KI: Persediaan barang
-- Pertanyaan: Barang apa saja yang stoknya perlu ditambah?
-- Perkiraan hasil: Menampilkan barang dengan stok di bawah stok minimum.

SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;


-- KI: Persediaan barang
-- Pertanyaan: Barang apa saja yang termasuk kategori ATK atau Minuman?
-- Perkiraan hasil: Menampilkan barang dari kedua kategori tersebut.

SELECT *
FROM barang
WHERE kategori_barang IN ('ATK', 'Minuman');


-- KI: Data penjualan
-- Pertanyaan: Transaksi apa saja yang terjadi selama September 2026?
-- Perkiraan hasil: Menampilkan nota penjualan pada bulan September 2026.

SELECT no_nota_penjualan, tgl_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-01 00:00:00'
                        AND '2026-09-30 23:59:59'
ORDER BY tgl_penjualan;


-- KI: Data anggota
-- Pertanyaan: Anggota mana yang belum memiliki nomor HP?
-- Perkiraan hasil: Menampilkan anggota dengan nomor HP bernilai NULL.

SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;


-- KI: Data anggota
-- Pertanyaan: Bagaimana format informasi anggota dan status diskonnya?
-- Perkiraan hasil: Menampilkan nama, nomor anggota, tanggal daftar,
-- nomor HP, dan keterangan diskon.

SELECT CONCAT(nama_anggota, ' (', no_anggota, ')') AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar_anggota,
       IFNULL(no_hp_anggota, '-') AS hp,
       CASE status_anggota
           WHEN 'aktif' THEN 'Diskon 5%'
           ELSE 'Tanpa diskon'
       END AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;


-- KI: Data anggota
-- Pertanyaan: Berapa lama setiap anggota telah terdaftar?
-- Perkiraan hasil: Menampilkan lama keanggotaan dalam hari
-- dan kategori baru atau lama.

SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS lama_hari,
       CASE
           WHEN DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180
           THEN 'baru'
           ELSE 'lama'
       END AS kategori
FROM anggota
ORDER BY tgl_daftar_anggota DESC;


-- KI: Detail transaksi penjualan
-- Pertanyaan: Berapa subtotal setiap barang pada nota PJ-2609-0142?
-- Perkiraan hasil: Menampilkan jumlah barang, harga satuan,
-- dan subtotal setiap baris transaksi.

SELECT id_penjualan, id_barang, qty_detail_penjualan,
       harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = 2;


-- KI: Persediaan barang
-- Pertanyaan: Bagaimana menampilkan nama barang dalam huruf kapital?
-- Perkiraan hasil: Menampilkan nama barang dalam format uppercase.

SELECT UPPER(nama_barang) AS nama_barang
FROM barang;


-- KI: Persediaan barang
-- Pertanyaan: Bagaimana menampilkan harga jual dalam format rupiah?
-- Perkiraan hasil: Menampilkan nama barang dan harga jual
-- dengan pemisah ribuan.

SELECT nama_barang,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga_rupiah
FROM barang;


-- KI: Data anggota
-- Pertanyaan: Siapa saja anggota yang berstatus aktif dan
-- memiliki nama yang mengandung huruf a?
-- Perkiraan hasil: Menampilkan anggota aktif yang namanya
-- mengandung huruf a.

SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE status_anggota = 'aktif'
  AND nama_anggota LIKE '%a%';

-- ============================================
-- E. LATIHAN DAN MODIFIKASI
-- ============================================

-- E.1
-- Pertanyaan: Bagaimana menampilkan nama barang
-- dalam huruf kapital dan harga dalam format Rupiah?
-- Perkiraan hasil: Nama barang uppercase dan harga
-- dengan awalan Rp serta pemisah ribuan.

SELECT
    UPPER(nama_barang) AS nama_barang,
    CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang;


-- E.2 - Kueri salah secara semantik
-- Pertanyaan: Menampilkan anggota dengan status aktif
-- atau nonaktif yang namanya mengandung huruf a.
-- Perkiraan hasil: Anggota aktif dapat tampil meskipun
-- nama tidak mengandung huruf a karena prioritas AND dan OR.

SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE status_anggota = 'aktif'
   OR status_anggota = 'nonaktif'
  AND nama_anggota LIKE '%a%';


-- E.2 - Kueri yang sudah diperbaiki
-- Perkiraan hasil: Hanya anggota dengan status aktif
-- atau nonaktif dan nama mengandung huruf a.

SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE (status_anggota = 'aktif'
       OR status_anggota = 'nonaktif')
  AND nama_anggota LIKE '%a%';