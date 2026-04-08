CREATE TABLE `passkey` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text,
	`public_key` text NOT NULL,
	`user_id` text NOT NULL,
	`credential_i_d` text NOT NULL,
	`counter` integer NOT NULL,
	`device_type` text NOT NULL,
	`backed_up` integer NOT NULL,
	`transports` text,
	`created_at` integer,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_bookings` (
	`id` text PRIMARY KEY NOT NULL,
	`property_id` text NOT NULL,
	`room_id` text NOT NULL,
	`guest_id` text NOT NULL,
	`check_in` text NOT NULL,
	`check_out` text NOT NULL,
	`adults` integer DEFAULT 1 NOT NULL,
	`children` integer DEFAULT 0 NOT NULL,
	`total_amount` integer NOT NULL,
	`payment_status` text DEFAULT 'pending' NOT NULL,
	`booking_status` text DEFAULT 'confirmed' NOT NULL,
	`notes` text,
	`created_at` integer DEFAULT 1775671638597 NOT NULL,
	`updated_at` integer DEFAULT 1775671638597 NOT NULL,
	FOREIGN KEY (`property_id`) REFERENCES `properties`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`room_id`) REFERENCES `rooms`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`guest_id`) REFERENCES `guests`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_bookings`("id", "property_id", "room_id", "guest_id", "check_in", "check_out", "adults", "children", "total_amount", "payment_status", "booking_status", "notes", "created_at", "updated_at") SELECT "id", "property_id", "room_id", "guest_id", "check_in", "check_out", "adults", "children", "total_amount", "payment_status", "booking_status", "notes", "created_at", "updated_at" FROM `bookings`;--> statement-breakpoint
DROP TABLE `bookings`;--> statement-breakpoint
ALTER TABLE `__new_bookings` RENAME TO `bookings`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE TABLE `__new_guests` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`name` text NOT NULL,
	`email` text,
	`phone` text,
	`address` text,
	`city` text,
	`state` text,
	`country` text,
	`zip_code` text,
	`id_type` text,
	`id_number` text,
	`notes` text,
	`created_at` integer DEFAULT 1775671638596 NOT NULL,
	`updated_at` integer DEFAULT 1775671638596 NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_guests`("id", "user_id", "name", "email", "phone", "address", "city", "state", "country", "zip_code", "id_type", "id_number", "notes", "created_at", "updated_at") SELECT "id", "user_id", "name", "email", "phone", "address", "city", "state", "country", "zip_code", "id_type", "id_number", "notes", "created_at", "updated_at" FROM `guests`;--> statement-breakpoint
DROP TABLE `guests`;--> statement-breakpoint
ALTER TABLE `__new_guests` RENAME TO `guests`;--> statement-breakpoint
CREATE TABLE `__new_payments` (
	`id` text PRIMARY KEY NOT NULL,
	`booking_id` text NOT NULL,
	`amount` integer NOT NULL,
	`method` text NOT NULL,
	`status` text DEFAULT 'completed' NOT NULL,
	`transaction_id` text,
	`notes` text,
	`created_at` integer DEFAULT 1775671638597 NOT NULL,
	`updated_at` integer DEFAULT 1775671638597 NOT NULL,
	FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_payments`("id", "booking_id", "amount", "method", "status", "transaction_id", "notes", "created_at", "updated_at") SELECT "id", "booking_id", "amount", "method", "status", "transaction_id", "notes", "created_at", "updated_at" FROM `payments`;--> statement-breakpoint
DROP TABLE `payments`;--> statement-breakpoint
ALTER TABLE `__new_payments` RENAME TO `payments`;--> statement-breakpoint
CREATE TABLE `__new_properties` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`name` text NOT NULL,
	`type` text NOT NULL,
	`address` text NOT NULL,
	`city` text NOT NULL,
	`state` text,
	`country` text NOT NULL,
	`zip_code` text,
	`phone` text,
	`email` text,
	`website` text,
	`description` text,
	`created_at` integer DEFAULT 1775671638596 NOT NULL,
	`updated_at` integer DEFAULT 1775671638596 NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_properties`("id", "user_id", "name", "type", "address", "city", "state", "country", "zip_code", "phone", "email", "website", "description", "created_at", "updated_at") SELECT "id", "user_id", "name", "type", "address", "city", "state", "country", "zip_code", "phone", "email", "website", "description", "created_at", "updated_at" FROM `properties`;--> statement-breakpoint
DROP TABLE `properties`;--> statement-breakpoint
ALTER TABLE `__new_properties` RENAME TO `properties`;--> statement-breakpoint
CREATE TABLE `__new_rooms` (
	`id` text PRIMARY KEY NOT NULL,
	`property_id` text NOT NULL,
	`name` text NOT NULL,
	`type` text NOT NULL,
	`capacity` integer NOT NULL,
	`rate` integer NOT NULL,
	`description` text,
	`amenities` text,
	`status` text DEFAULT 'available' NOT NULL,
	`created_at` integer DEFAULT 1775671638596 NOT NULL,
	`updated_at` integer DEFAULT 1775671638596 NOT NULL,
	FOREIGN KEY (`property_id`) REFERENCES `properties`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_rooms`("id", "property_id", "name", "type", "capacity", "rate", "description", "amenities", "status", "created_at", "updated_at") SELECT "id", "property_id", "name", "type", "capacity", "rate", "description", "amenities", "status", "created_at", "updated_at" FROM `rooms`;--> statement-breakpoint
DROP TABLE `rooms`;--> statement-breakpoint
ALTER TABLE `__new_rooms` RENAME TO `rooms`;--> statement-breakpoint
CREATE TABLE `__new_user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text,
	`email` text NOT NULL,
	`email_verified` integer NOT NULL,
	`image` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
INSERT INTO `__new_user`("id", "name", "email", "email_verified", "image", "created_at", "updated_at") SELECT "id", "name", "email", "email_verified", "image", "created_at", "updated_at" FROM `user`;--> statement-breakpoint
DROP TABLE `user`;--> statement-breakpoint
ALTER TABLE `__new_user` RENAME TO `user`;--> statement-breakpoint
CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);