<?php

    function fnCheckData($kon, $tbl, $where){
        $SQLAdd = 
            "SELECT * FROM ".$tbl." WHERE ".$where;
        $query = mysqli_query($kon, $SQLAdd);
        if (mysqli_num_rows($query) > 0){
            return FALSE;
        } else {
            return TRUE;
        }
    }

    function fnGetItem($kon, $tbl, $val, $isWhere, $order, $limit){
		$index = 0;

        $SQLAdd = '';
        if ($isWhere != '') {
            $SQLAdd = 'WHERE';
        }
		
		$SQLAdd =
			"SELECT ".$val." FROM ".$tbl." ".$SQLAdd." ".$isWhere." ".$order." LIMIT 20";

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

    function fnDeleteItem($kon, $id, $nmTable){
        $index = 0;
        $SQLAdd =
            "DELETE FROM ".$nmTable." WHERE id = '".$id."'";

        if (mysqli_query($kon, $SQLAdd)) {
            $respon[$index]['result'] = "SUKSES";
            $respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
        } else {
            $respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
        }
        
        return $respon;
    }

    function fnDeleteSubItem($kon, $id, $sub, $nmTable){
        $index = 0;
        $SQLAdd =
            "DELETE FROM ".$nmTable." WHERE ".$sub." = '".$id."'";

        if (mysqli_query($kon, $SQLAdd)) {
            $respon[$index]['result'] = "SUKSES";
            $respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
        } else {
            $respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
        }
    }

    function fnDeleteItemWhere($kon, $nmTable, $isWhere){
        $index = 0;
        $SQLAdd =
            "DELETE FROM ".$nmTable." WHERE ".$isWhere."";

        if (mysqli_query($kon, $SQLAdd)) {
            $respon[$index]['result'] = "SUKSES";
            $respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
        } else {
            $respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
        }
        
        return $respon;
    }

    function fnInsertItem($kon, $tbl, $kol, $val){
        $index = 0;
        #$val = fnExplode($val);

		$SQLAdd =
            "INSERT INTO ".$tbl." (".$kol.") VALUES (".$val.")";

        if (mysqli_query($kon, $SQLAdd)) {
            $respon[$index]['result'] = "SUKSES";
            $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
        } else {
            $respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
        }
		
		return $respon;
	}

    function fnInsertItemIsNull($kon, $tbl, $kol, $val, $isWhere){
		$index = 0;
        #$val = fnExplode($val);

		$SQLAdd = 
			"SELECT * FROM ".$tbl." WHERE ".$isWhere;
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) > 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'Already exist';
		} else {
			$SQLAdd =
                "INSERT INTO ".$tbl." (".$kol.") VALUES (".$val.")";

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'Data Success Input';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'Sorry, Data Failed to Input';
                #$respon[$index]['SQL'] = $SQLAdd;
			}
		}
		
		return $respon;
	}

    function fnInsertItemIsNotNull($kon, $tbl, $kol, $val, $isWhere){
		$index = 0;
        #$val = fnExplode($val);

		$SQLAdd = 
			"SELECT * FROM ".$tbl." WHERE ".$isWhere;
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) == 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'Already exist';
		} else {
			$SQLAdd =
                "INSERT INTO ".$tbl." (".$kol.") VALUES (".$val.")";

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
			}
		}
		
		return $respon;
	}

    function fnUpdateItem($kon, $tbl, $val, $isWHere){
		$index = 0;

		$SQLAdd =
            "UPDATE ".$tbl." SET ".$val." WHERE ".$isWHere;

        if (mysqli_query($kon, $SQLAdd)) {
            $respon[$index]['result'] = "SUKSES";
            $respon[$index]['pesan'] = 'DATA BERHASIL DI UBAH';
        } else {
            $respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'MAAF, DATA GAGAL UBAH';
        }
		
		return $respon;
	}

    function fnUpdateItemIsNull($kon, $tbl, $val, $id, $isWhere){
		$index = 0;

		$SQLAdd = 
			"SELECT * FROM ".$tbl." WHERE ".$isWhere." AND id NOT IN ('".$id."')";
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) > 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'Already exist';
		} else {
			$SQLAdd =
                "UPDATE ".$tbl." SET ".$val." WHERE id = '".$id."'";

            #echo $SQLAdd;

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
			}
		}
		
		return $respon;
	}

    function fnUpdateItemIsNotNull($kon, $tbl, $val, $id, $isWhere){
		$index = 0;

		$SQLAdd = 
			"SELECT * FROM ".$tbl." WHERE ".$isWhere;
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) == 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'Already exist';
		} else {
			$SQLAdd =
                "UPDATE ".$tbl." SET ".$val." WHERE id = '".$id."'";

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
			}
		}
		
		return $respon;
    }
    
	
?>