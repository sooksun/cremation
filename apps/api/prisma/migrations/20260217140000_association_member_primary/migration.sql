-- สมาชิกสมาคมเป็นหลัก สมาชิกฌาปนกิจอ้างอิงจากสมาชิกสมาคม
-- Step 1: Add person fields to AssociationMember
ALTER TABLE `AssociationMember`
  ADD COLUMN `firstName` VARCHAR(191) NULL,
  ADD COLUMN `lastName` VARCHAR(191) NULL,
  ADD COLUMN `idCardNo` VARCHAR(191) NULL,
  ADD COLUMN `birthDate` DATETIME(3) NULL,
  ADD COLUMN `address` VARCHAR(191) NULL,
  ADD COLUMN `phone` VARCHAR(191) NULL;

-- Step 2: Copy person data from Member to AssociationMember (for existing links)
UPDATE `AssociationMember` am
INNER JOIN `Member` m ON am.memberId = m.id
SET
  am.firstName = m.firstName,
  am.lastName = m.lastName,
  am.idCardNo = m.idCardNo,
  am.birthDate = m.birthDate,
  am.address = m.address,
  am.phone = m.phone;

-- Step 3: Add associationMemberId to Member (nullable first)
ALTER TABLE `Member` ADD COLUMN `associationMemberId` VARCHAR(191) NULL;
CREATE UNIQUE INDEX `Member_associationMemberId_key` ON `Member`(`associationMemberId`);

-- Step 4: Link Member -> AssociationMember where AssociationMember already exists
UPDATE `Member` m
INNER JOIN `AssociationMember` am ON am.memberId = m.id
SET m.associationMemberId = am.id;

-- Step 5: For Members without AssociationMember, create AssociationMember and link
INSERT INTO `AssociationMember` (
  `id`, `memberId`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `idCardNo`, `birthDate`, `address`, `phone`,
  `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`
)
SELECT
  UUID(), m.id, m.schoolId, m.memberTypeId, m.firstName, m.lastName, m.idCardNo, m.birthDate, m.address, m.phone,
  NULL, NULL, m.joinDate, NULL, NOW(3), NOW(3)
FROM `Member` m
WHERE m.associationMemberId IS NULL;

UPDATE `Member` m
INNER JOIN `AssociationMember` am ON am.memberId = m.id
SET m.associationMemberId = am.id
WHERE m.associationMemberId IS NULL;

-- Step 6: Make AssociationMember person fields NOT NULL (use placeholder for any nulls)
UPDATE `AssociationMember` SET firstName = COALESCE(firstName, '—'), lastName = COALESCE(lastName, '—') WHERE firstName IS NULL OR lastName IS NULL;
ALTER TABLE `AssociationMember`
  MODIFY COLUMN `firstName` VARCHAR(191) NOT NULL,
  MODIFY COLUMN `lastName` VARCHAR(191) NOT NULL;

-- Step 7: Drop old AssociationMember -> Member FK and column
ALTER TABLE `AssociationMember` DROP FOREIGN KEY `AssociationMember_memberId_fkey`;
ALTER TABLE `AssociationMember` DROP COLUMN `memberId`;

-- Step 8: Drop Member person/type columns and make associationMemberId required
ALTER TABLE `Member` DROP FOREIGN KEY `Member_memberTypeId_fkey`;
ALTER TABLE `Member`
  DROP COLUMN `memberTypeId`,
  DROP COLUMN `firstName`,
  DROP COLUMN `lastName`,
  DROP COLUMN `idCardNo`,
  DROP COLUMN `birthDate`,
  DROP COLUMN `address`,
  DROP COLUMN `phone`;

ALTER TABLE `Member` MODIFY COLUMN `associationMemberId` VARCHAR(191) NOT NULL;

-- Step 9: Add FK Member.associationMemberId -> AssociationMember.id
ALTER TABLE `Member` ADD CONSTRAINT `Member_associationMemberId_fkey` FOREIGN KEY (`associationMemberId`) REFERENCES `AssociationMember`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
