/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : db_pethome

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 18/05/2025 09:15:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_announcement
-- ----------------------------
DROP TABLE IF EXISTS `tb_announcement`;
CREATE TABLE `tb_announcement`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `createBy` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_announcement
-- ----------------------------
INSERT INTO `tb_announcement` VALUES (1, '系统维护通知', '由于系统维护，服务将于12月20日暂停。', '2024-12-20 10:20:17', 2);
INSERT INTO `tb_announcement` VALUES (2, '宠物领养活动', '本周六将举行宠物领养活动，欢迎大家参加！', '2024-12-20 10:20:17', 2);

-- ----------------------------
-- Table structure for tb_favorite_folder
-- ----------------------------
DROP TABLE IF EXISTS `tb_favorite_folder`;
CREATE TABLE `tb_favorite_folder`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '创建收藏夹的用户ID',
  `folder_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收藏夹名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收藏夹描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_folder_user` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_favorite_folder
-- ----------------------------
INSERT INTO `tb_favorite_folder` VALUES (1, 1, '默认收藏夹', NULL, '2025-05-18 00:00:00');
INSERT INTO `tb_favorite_folder` VALUES (2, 1, 'test1', 'text', '2025-05-18 01:17:19');
INSERT INTO `tb_favorite_folder` VALUES (3, 1, 'test2', '', '2025-05-18 01:17:45');
INSERT INTO `tb_favorite_folder` VALUES (4, 1, 'test3', '', '2025-05-18 01:17:52');
INSERT INTO `tb_favorite_folder` VALUES (5, 1, 'test4', '', '2025-05-18 01:17:56');

-- ----------------------------
-- Table structure for tb_favorite_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_favorite_item`;
CREATE TABLE `tb_favorite_item`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `folder_id` int NOT NULL COMMENT '所属收藏夹ID',
  `pet_id` int NOT NULL COMMENT '收藏的宠物ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `pet_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '宠物类型',
  `count` int NOT NULL DEFAULT 1 COMMENT '收藏数量',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_folder_pet`(`folder_id` ASC, `pet_id` ASC) USING BTREE,
  INDEX `folder_id`(`folder_id` ASC) USING BTREE,
  INDEX `pet_id`(`pet_id` ASC) USING BTREE,
  INDEX `pet_type`(`pet_type` ASC) USING BTREE,
  CONSTRAINT `fk_item_folder` FOREIGN KEY (`folder_id`) REFERENCES `tb_favorite_folder` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_pet` FOREIGN KEY (`pet_id`) REFERENCES `tb_pet` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_favorite_item
-- ----------------------------
INSERT INTO `tb_favorite_item` VALUES (1, 1, 1, '2025-05-18 09:11:40', 'dog', 1, '2025-05-18 09:11:40');

-- ----------------------------
-- Table structure for tb_pet
-- ----------------------------
DROP TABLE IF EXISTS `tb_pet`;
CREATE TABLE `tb_pet`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `breed` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `age` int NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int NOT NULL,
  `adopt_id` int NULL DEFAULT NULL,
  `adopted` enum('no','undetermined','yes') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tb_pet_ibfk_1`(`user_id` ASC) USING BTREE,
  INDEX `tb_pet_ibfk_2`(`adopt_id` ASC) USING BTREE,
  CONSTRAINT `tb_pet_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tb_pet_ibfk_2` FOREIGN KEY (`adopt_id`) REFERENCES `tb_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_pet
-- ----------------------------
INSERT INTO `tb_pet` VALUES (1, 'Tommy', 'dog', '泰迪', 1, '可爱的小狗', 'upload/OIP-C (3).jpg,upload/OIP-C (4).jpg,upload/OIP-C (5).jpg', 'approved', '2025-01-03 23:48:04', 2, 5, 'yes');
INSERT INTO `tb_pet` VALUES (4, '小东西', 'dog', '金毛', 1, '可爱的小狗', 'upload/OIP-C (3).jpg,upload/OIP-C (4).jpg,upload/OIP-C (5).jpg,upload/OIP-C (6).jpg', 'approved', '2025-01-04 00:09:29', 2, 5, 'undetermined');
INSERT INTO `tb_pet` VALUES (5, 'LIli', 'cat', '小猫', 2, '可爱的小猫', 'upload/OIP-C (1).jpg,upload/OIP-C (2).jpg,upload/OIP-C.jpg', 'approved', '2025-01-04 00:09:48', 2, 5, 'undetermined');
INSERT INTO `tb_pet` VALUES (6, 'nacy', 'mouse', '仓鼠', 2, '可爱的仓鼠', 'upload/OIP-C (7).jpg,upload/OIP-C (8).jpg,upload/OIP-C (9).jpg', 'approved', '2025-01-04 00:09:59', 2, NULL, 'no');
INSERT INTO `tb_pet` VALUES (7, 'bob', 'mouse', '金丝熊', 3, '可爱的金丝熊', 'upload/OIP-C (7).jpg,upload/OIP-C (8).jpg,upload/OIP-C (9).jpg', 'approved', '2025-01-04 00:10:09', 2, NULL, 'no');
INSERT INTO `tb_pet` VALUES (8, 'Heili', 'dog', '泰迪', 5, '可爱的泰迪', 'upload/OIP-C (6).jpg,upload/taidi.png', 'approved', '2025-01-04 00:10:23', 2, NULL, 'no');
INSERT INTO `tb_pet` VALUES (9, 'momo', 'dog', '哈士奇', 6, '凶猛的哈士奇', 'upload/OIP-C (4).jpg,upload/OIP-C (6).jpg,upload/taidi.png', 'approved', '2025-01-04 00:10:33', 2, NULL, 'no');
INSERT INTO `tb_pet` VALUES (10, 'GGbon', 'dog', '泰迪', 2, '可爱的小狗', 'upload/OIP-C (5).jpg', 'approved', '2025-01-06 01:33:43', 5, NULL, 'no');
INSERT INTO `tb_pet` VALUES (11, 'kkk', 'dog', '泰迪', 2, '可爱的小狗', 'upload/OIP-C (10).jpg,upload/OIP-C (11).jpg', 'pending', '2025-01-06 01:39:10', 5, NULL, 'no');
INSERT INTO `tb_pet` VALUES (12, 'haha', 'dog', '哈士奇', 2, '凶猛的哈士奇', 'upload/OIP-C (11).jpg', 'approved', '2025-01-06 01:39:53', 5, NULL, 'no');
INSERT INTO `tb_pet` VALUES (13, 'nana', 'snake', '眼镜蛇', 2, '眼镜蛇', 'upload/OIP-C (12).jpg,upload/下载.jpg', 'approved', '2025-01-06 01:40:59', 5, NULL, 'no');
INSERT INTO `tb_pet` VALUES (14, 'Qpig', 'pig', '小香猪', 2, '小香猪', 'upload/OIP-C (13).jpg,upload/OIP-C (14).jpg', 'approved', '2025-01-06 01:41:42', 5, NULL, 'no');

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('user','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (1, 'user', '123', 'tom@example.com', 'user', '2024-12-20 10:20:17');
INSERT INTO `tb_user` VALUES (2, 'admin', 'admin123', 'admin@example.com', 'admin', '2024-12-20 10:20:17');
INSERT INTO `tb_user` VALUES (3, 'user1', '12345', '123@456', 'user', '2024-12-20 13:49:47');
INSERT INTO `tb_user` VALUES (5, 'user2', '123456789', '3334567896@qq.com', 'user', '2024-12-20 13:55:27');
INSERT INTO `tb_user` VALUES (6, 'user3', '12345678', '2816978150@qq.com', 'user', '2024-12-20 15:20:51');
INSERT INTO `tb_user` VALUES (7, 'user4', '12345678', '123@123', 'user', '2024-12-20 17:21:05');
INSERT INTO `tb_user` VALUES (8, 'user5', '123456789', '3218069175@qq.com', 'user', '2024-12-20 17:21:26');
INSERT INTO `tb_user` VALUES (9, 'user6', '123456789', 'wuzhenyi822@gmail.com', 'user', '2024-12-20 17:21:44');
INSERT INTO `tb_user` VALUES (10, 'user7', '87654321', '456@456', 'user', '2024-12-20 17:22:16');
INSERT INTO `tb_user` VALUES (11, 'admin1', 'admin123', '24567@7895', 'admin', '2024-12-20 17:23:05');
INSERT INTO `tb_user` VALUES (12, 'admin2', 'admin123', '789@789', 'admin', '2024-12-20 17:23:36');
INSERT INTO `tb_user` VALUES (13, 'admin3', 'admin123', '4711@5552', 'admin', '2024-12-20 17:30:32');
INSERT INTO `tb_user` VALUES (14, 'user8', '12345678', '123@123', 'user', '2024-12-24 16:35:16');
INSERT INTO `tb_user` VALUES (15, 'user9', 'password123', '123@456', 'user', '2024-12-24 16:35:34');
INSERT INTO `tb_user` VALUES (16, 'user10', 'password123', '2816978150@qq.com', 'user', '2024-12-24 16:35:45');
INSERT INTO `tb_user` VALUES (18, 'user11', 'password123', '123@123', 'user', '2024-12-30 19:55:07');
INSERT INTO `tb_user` VALUES (19, 'user12', '123456789', '2816978150@qq.com', 'user', '2024-12-31 15:06:06');
INSERT INTO `tb_user` VALUES (22, 'user13', '123456789', '4711@5552', 'user', '2025-01-02 19:57:14');
INSERT INTO `tb_user` VALUES (23, 'admin4', 'admin123', '2816978150@qq.com', 'user', '2025-01-02 19:58:09');
INSERT INTO `tb_user` VALUES (24, 'user14', '123456789', '4711@5552', 'user', '2025-01-03 15:55:34');
INSERT INTO `tb_user` VALUES (25, 'user15', 'password123', '123@456', 'user', '2025-01-03 15:57:46');
INSERT INTO `tb_user` VALUES (26, 'user16', 'password123', '123@456', 'user', '2025-01-04 02:28:46');

SET FOREIGN_KEY_CHECKS = 1;
