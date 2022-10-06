/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 100418
 Source Host           : localhost:3306
 Source Schema         : db_biodata

 Target Server Type    : MySQL
 Target Server Version : 100418
 File Encoding         : 65001

 Date: 07/12/2021 15:44:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_siswa
-- ----------------------------
DROP TABLE IF EXISTS `tb_siswa`;
CREATE TABLE `tb_siswa`  (
  `id_siswa` int NOT NULL AUTO_INCREMENT,
  `cdt` datetime NULL DEFAULT current_timestamp,
  `udt` datetime NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  `nip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `kelas` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `alamat` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `notelp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `hobi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_siswa`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_siswa
-- ----------------------------
INSERT INTO `tb_siswa` VALUES (2, '2021-12-07 14:15:43', '2021-12-07 15:21:30', '00001', 'Fajar Donny Bachtiar', 'VI', 'Sleman Barat', '089683339333', 'Sepak Bola');
INSERT INTO `tb_siswa` VALUES (6, '2021-12-07 14:15:43', '2021-12-07 15:14:19', '00002', 'Janoko', 'V', 'Sleman', '089683339333', 'Sepak Bola');
INSERT INTO `tb_siswa` VALUES (7, '2021-12-07 14:15:43', '2021-12-07 15:37:08', '00003', 'Paijo', 'III', 'Sleman', '089683339333', 'Sepak Bola');
INSERT INTO `tb_siswa` VALUES (8, '2021-12-07 14:15:43', '2021-12-07 15:37:11', '00004', 'Putra Bangsa', 'III', 'Sleman', '089683339333', 'Sepak Bola');

SET FOREIGN_KEY_CHECKS = 1;
