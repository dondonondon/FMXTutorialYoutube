<?php
    include_once 'function.php';
	
    function fnLoadDataGroup($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT kelas, COALESCE(COUNT(kelas),0) total_data FROM tb_siswa GROUP BY kelas ORDER BY kelas ASC";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_assoc($query)) {
				$respon[] = $list;
			}
		} elseif (mysqli_num_rows($query) == 0){
            $respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF, BELUM ADA DATA';	
        } else {
            $respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'BERMASALAH SAAT MENGAMBIL DATA';	
        }

		return $respon;
	}
	
    
?>