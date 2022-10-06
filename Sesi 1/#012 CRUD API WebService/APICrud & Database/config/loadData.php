<?php
    include_once 'function.php';
	
    function fnLoadEmas($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT * FROM tbl_saran";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_assoc($query)) {
				$respon[] = $list;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF, BELUM ADA DATA';	
		}

		return $respon;
	}
	
    
?>