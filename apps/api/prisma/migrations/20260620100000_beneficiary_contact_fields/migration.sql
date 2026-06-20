-- Preserve the beneficiary details captured by the membership application form.
ALTER TABLE `Beneficiary`
  ADD COLUMN `nationalId` VARCHAR(191) NULL,
  ADD COLUMN `houseNo` VARCHAR(191) NULL,
  ADD COLUMN `moo` VARCHAR(191) NULL,
  ADD COLUMN `road` VARCHAR(191) NULL,
  ADD COLUMN `soi` VARCHAR(191) NULL,
  ADD COLUMN `subdistrict` VARCHAR(191) NULL,
  ADD COLUMN `district` VARCHAR(191) NULL,
  ADD COLUMN `province` VARCHAR(191) NULL,
  ADD COLUMN `zip` VARCHAR(191) NULL,
  ADD COLUMN `contactPerson` VARCHAR(191) NULL,
  ADD COLUMN `contactPhone` VARCHAR(191) NULL;
