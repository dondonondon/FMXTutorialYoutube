/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 100418
 Source Host           : localhost:3306
 Source Schema         : db_tutorial

 Target Server Type    : MySQL
 Target Server Version : 100418
 File Encoding         : 65001

 Date: 10/09/2021 15:03:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tbl_data
-- ----------------------------
DROP TABLE IF EXISTS `tbl_data`;
CREATE TABLE `tbl_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cdt` datetime(0) NULL DEFAULT current_timestamp(),
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `kelas` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `hobi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_data
-- ----------------------------
INSERT INTO `tbl_data` VALUES (4, '2021-09-10 13:19:05', 'Fajar Donny', 'XII A', 'Basket');
INSERT INTO `tbl_data` VALUES (6, '2021-09-10 13:20:20', 'Joko', 'XII C', 'Sepeda');
INSERT INTO `tbl_data` VALUES (9, '2021-09-10 14:40:08', 'Jono', 'X A', 'Sepak Bola');

SET FOREIGN_KEY_CHECKS = 1;
