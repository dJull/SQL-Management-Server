CREATE VIEW vwPemesanan AS
SELECT D.Kode_Pesanan,H.Tanggal_Pesan,C.Kode_Customer,P.Kode_Produk,D.Kuantitas,D.Total_Harga,D.Total_Bayar FROM Header_Pesanan H
JOIN Customer C ON H.Kode_Customer=C.Kode_Customer
JOIN Detail_Pesanan D ON H.Kode_Pesanan=D.Kode_Pesanan
JOIN Produk P ON D.Kode_Produk=P.Kode_Produk;

CREATE VIEW vwJumlahPemesananperProduk AS
SELECT P.Kode_Produk,COUNT(D.Kode_Pesanan),SUM(D.Kuantitas),(D.Total_Harga*10/100) AS PPN,(D.Total_Bayar+D.Total_Harga) AS Total_BiayaBelanja FROM Header_Pesanan H
JOIN Customer C ON H.Kode_Customer=C.Kode_Customer
JOIN Detail_Pesanan D ON H.Kode_Pesanan=D.Kode_Pesanan
JOIN Produk P ON D.Kode_Produk=P.Kode_Produk;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[validasiData] ON [dbo].[Detail_Pesanan]
   AFTER INSERT
AS 
BEGIN
	
	declare @Total_Bayar int;
	declare @Total_Harga int;

	SELECT @Total_Harga = harga.Total_Harga from inserted harga;
	SELECT @Total_Bayar = @Total_Harga+@Total_Harga*10/100
	
	INSERT INTO Detail_Pesanan(Total_Bayar)
	VALUES(@Total_Bayar)

END
GO

SELECT P.Kode_Produk,H.Kode_Pesanan,D.Kuantitas FROM Header_Pesanan H
JOIN Customer C ON H.Kode_Customer=C.Kode_Customer
JOIN Detail_Pesanan D ON H.Kode_Pesanan=D.Kode_Pesanan
JOIN Produk P ON D.Kode_Produk=P.Kode_Produk;

SELECT * FROM   
(
    SELECT 
        Kode_Pesanan, 
        Kode_Produk,
        Kuantitas
    FROM 
        dbo.Detail_Pesanan d
) t 
PIVOT(
    COUNT(Kuantitas) 
    FOR Kode_Produk IN (
        [PR100], 
        [PR1000], 
        [PR200], 
        [PR300], 
        [PR400], 
        [PR500], 
        [PR600],
		[PR700],
		[PR800],
		[PR900])
) AS pivot_table;


