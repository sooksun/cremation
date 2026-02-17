-- Migration: Add signature field to User table
-- Run this SQL command in your MySQL database

ALTER TABLE `User` ADD COLUMN IF NOT EXISTS `signature` TEXT NULL COMMENT 'ลายเซ็นอิเล็กทรอนิกส์ (base64 image)';

