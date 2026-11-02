-- Modul 6: Mengisi, Mengubah, dan Menguji Data dengan DML
-- Nama file: p06_data_kopma_25430035.sql
-- Jalankan hanya pada database uji: kopma_035_uji
-- Catatan: skrip ini memakai INSERT bersyarat agar tidak menggandakan kode yang sudah ada.

USE kopma_035_uji;

-- D.1 Data petugas (kolom mengikuti Modul 6)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
SELECT 'K06', 'Dimas Uji', 'kasir'
WHERE NOT EXISTS (SELECT 1 FROM petugas WHERE kode_petugas = 'K06');

INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
SELECT 'K07', 'Sari Uji', 'kasir'
WHERE NOT EXISTS (SELECT 1 FROM petugas WHERE kode_petugas = 'K07');

INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
SELECT 'K08', 'Rina Uji', 'kasir'
WHERE NOT EXISTS (SELECT 1 FROM petugas WHERE kode_petugas = 'K08');

INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
SELECT 'G06', 'Joko Uji', 'gudang'
WHERE NOT EXISTS (SELECT 1 FROM petugas WHERE kode_petugas = 'G06');

INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
SELECT 'P06', 'Ketua Kopma Uji', 'ketua'
WHERE NOT EXISTS (SELECT 1 FROM petugas WHERE kode_petugas = 'P06');

-- D.1 Data barang. Kode ATK-001 s.d. MKN-001 mengikuti contoh modul.
INSERT INTO barang
    (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
SELECT 'ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 120, 20
WHERE NOT EXISTS (SELECT 1 FROM barang WHERE kode_barang = 'ATK-001');

INSERT INTO barang
    (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
SELECT 'ATK-002', 'Buku Tulis 58', 'ATK', 6500, 80, 20
WHERE NOT EXISTS (SELECT 1 FROM barang WHERE kode_barang = 'ATK-002');

INSERT INTO barang
    (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
SELECT 'MNM-001', 'Air Mineral 600', 'minuman', 4000, 48, 24
WHERE NOT EXISTS (SELECT 1 FROM barang WHERE kode_barang = 'MNM-001');

INSERT INTO barang
    (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
SELECT 'MKN-001', 'Roti Cokelat', 'makanan', 5000, 6, 10
WHERE NOT EXISTS (SELECT 1 FROM barang WHERE kode_barang = 'MKN-001');

-- Anggota dan pemasok:
-- Database kopma_035_uji saat ini sudah memiliki minimal 3 anggota (termasuk
-- satu nonaktif) dan 2 pemasok. Periksa sebelum menambahkan data tambahan:
SELECT no_anggota, nim_anggota, nama_anggota, status_anggota FROM anggota;
SELECT * FROM pemasok;

-- Catatan transaksi:
-- Modul meminta nota PJ-2609-0142. Pada database uji yang sedang dipakai,
-- nota ini sudah ada (id_penjualan = 2), jadi jangan INSERT ulang di sini.
SELECT id_penjualan, no_nota_penjualan, id_petugas, id_anggota
FROM penjualan
WHERE no_nota_penjualan = 'PJ-2609-0142';

-- Pemeriksaan hasil data induk
SELECT kode_petugas, nama_petugas, peran_petugas FROM petugas ORDER BY kode_petugas;
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang
FROM barang
ORDER BY kode_barang;
