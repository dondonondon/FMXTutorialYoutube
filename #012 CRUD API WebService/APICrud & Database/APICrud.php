<?php
    include_once 'config/config.php';
    include_once 'config/function.php';
    include_once 'config/loadData.php';
	
	header("Content-Type: application/json; charset=UTF-8");

	$index = 0;
	$respon = array(); 

	if (empty($_GET['act'])) {
		$respon[$index]['result'] = 'null';
		$respon[$index]['pesan'] = 'No action';
	} else {
		if (!$koneksi) {
			$respon[$index]['result'] = 'null';
			$respon[$index]['pesan'] = 'MAAF GAGAL MENGHUBUNGKAN DENGAN SERVER';	
		} else {
			if ($_GET['act'] == 'deleteItem'){ 
				$respon = fnDeleteItem($koneksi, $_POST['id'], $_POST['tbl']);
			} elseif ($_GET['act'] == 'deleteItemWhere') {
				$respon = fnDeleteItemWhere($koneksi, $_POST['tbl'], $_POST['isWhere']);
			} elseif ($_GET['act'] == 'insertItem') {
				$respon = fnInsertItem($koneksi, $_POST['tbl'], $_POST['kol'], $_POST['val']);
			} elseif ($_GET['act'] == 'insertItemIsNull') {
				$respon = fnInsertItemIsNull($koneksi, $_POST['tbl'], $_POST['kol'], $_POST['val'], $_POST['isWhere']);
			} elseif ($_GET['act'] == 'insertItemIsNotNull') {
				$respon = fnInsertItemIsNotNull($koneksi, $_POST['tbl'], $_POST['kol'], $_POST['val'], $_POST['isWhere']);
			} elseif ($_GET['act'] == 'updateItem') {
				$respon = fnUpdateItem($koneksi, $_POST['tbl'], $_POST['val'], $_POST['isWhere']);	
			} elseif ($_GET['act'] == 'updateItemIsNull') {
				$respon = fnUpdateItemIsNull($koneksi, $_POST['tbl'], $_POST['val'], $_POST['id'], $_POST['isWhere']);
			} elseif ($_GET['act'] == 'updateItemIsNotNull') {
				$respon = fnUpdateItemIsNotNull($koneksi, $_POST['tbl'], $_POST['val'], $_POST['id'], $_POST['isWhere']);
			} elseif ($_GET['act'] == 'loadItem') {
				$respon = fnGetItem($koneksi, $_POST['tbl'], $_POST['val'], $_POST['isWhere'], $_POST['order'], $_POST['limit']);
			} else {
				$respon[$index]['result'] = "null";
				$respon[$index]['pesan'] = 'Invalid action';
			}
		}
	}
	
	echo json_encode($respon,JSON_PRETTY_PRINT);
?>