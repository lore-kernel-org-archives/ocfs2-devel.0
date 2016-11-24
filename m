From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:36 +0100
Subject: [Ocfs2-devel] [PATCH 1/7] fs: Provide function to get superblock
	with exclusive s_umount
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Quota code will need a variant of get_super_thawed() that returns
superblock with s_umount held in exclusive mode to serialize quota on
and quota off operations. Provide this functionality.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         | 80 ++++++++++++++++++++++++++++++++++++++++--------------
 include/linux/fs.h |  2 ++
 2 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c183835566c1..f7f724230e2b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -558,6 +558,13 @@ void drop_super(struct super_block *sb)
 
 EXPORT_SYMBOL(drop_super);
 
+void drop_super_exclusive(struct super_block *sb)
+{
+	up_write(&sb->s_umount);
+	put_super(sb);
+}
+EXPORT_SYMBOL(drop_super_exclusive);
+
 /**
  *	iterate_supers - call function for all active superblocks
  *	@f: function to call
@@ -628,15 +635,7 @@ void iterate_supers_type(struct file_system_type *type,
 
 EXPORT_SYMBOL(iterate_supers_type);
 
-/**
- *	get_super - get the superblock of a device
- *	@bdev: device to get the superblock for
- *	
- *	Scans the superblock list and finds the superblock of the file system
- *	mounted on the device given. %NULL is returned if no match is found.
- */
-
-struct super_block *get_super(struct block_device *bdev)
+static struct super_block *__get_super(struct block_device *bdev, bool excl)
 {
 	struct super_block *sb;
 
@@ -651,11 +650,17 @@ struct super_block *get_super(struct block_device *bdev)
 		if (sb->s_bdev == bdev) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
-			down_read(&sb->s_umount);
+			if (!excl)
+				down_read(&sb->s_umount);
+			else
+				down_write(&sb->s_umount);
 			/* still alive? */
 			if (sb->s_root && (sb->s_flags & MS_BORN))
 				return sb;
-			up_read(&sb->s_umount);
+			if (!excl)
+				up_read(&sb->s_umount);
+			else
+				up_write(&sb->s_umount);
 			/* nope, got unmounted */
 			spin_lock(&sb_lock);
 			__put_super(sb);
@@ -666,32 +671,67 @@ struct super_block *get_super(struct block_device *bdev)
 	return NULL;
 }
 
-EXPORT_SYMBOL(get_super);
-
 /**
- *	get_super_thawed - get thawed superblock of a device
+ *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
  *
  *	Scans the superblock list and finds the superblock of the file system
- *	mounted on the device. The superblock is returned once it is thawed
- *	(or immediately if it was not frozen). %NULL is returned if no match
- *	is found.
+ *	mounted on the device given. %NULL is returned if no match is found.
  */
-struct super_block *get_super_thawed(struct block_device *bdev)
+struct super_block *get_super(struct block_device *bdev)
+{
+	return __get_super(bdev, false);
+}
+EXPORT_SYMBOL(get_super);
+
+static struct super_block *__get_super_thawed(struct block_device *bdev,
+					      bool excl)
 {
 	while (1) {
-		struct super_block *s = get_super(bdev);
+		struct super_block *s = __get_super(bdev, excl);
 		if (!s || s->s_writers.frozen == SB_UNFROZEN)
 			return s;
-		up_read(&s->s_umount);
+		if (!excl)
+			up_read(&s->s_umount);
+		else
+			up_write(&s->s_umount);
 		wait_event(s->s_writers.wait_unfrozen,
 			   s->s_writers.frozen == SB_UNFROZEN);
 		put_super(s);
 	}
 }
+
+/**
+ *	get_super_thawed - get thawed superblock of a device
+ *	@bdev: device to get the superblock for
+ *
+ *	Scans the superblock list and finds the superblock of the file system
+ *	mounted on the device. The superblock is returned once it is thawed
+ *	(or immediately if it was not frozen). %NULL is returned if no match
+ *	is found.
+ */
+struct super_block *get_super_thawed(struct block_device *bdev)
+{
+	return __get_super_thawed(bdev, false);
+}
 EXPORT_SYMBOL(get_super_thawed);
 
 /**
+ *	get_super_exclusive_thawed - get thawed superblock of a device
+ *	@bdev: device to get the superblock for
+ *
+ *	Scans the superblock list and finds the superblock of the file system
+ *	mounted on the device. The superblock is returned once it is thawed
+ *	(or immediately if it was not frozen) and s_umount semaphore is held
+ *	in exclusive mode. %NULL is returned if no match is found.
+ */
+struct super_block *get_super_exclusive_thawed(struct block_device *bdev)
+{
+	return __get_super_thawed(bdev, true);
+}
+EXPORT_SYMBOL(get_super_exclusive_thawed);
+
+/**
  * get_active_super - get an active reference to the superblock of a device
  * @bdev: device to get the superblock for
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0478c07b2a..d04cfdefcd11 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2949,8 +2949,10 @@ extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *get_super_thawed(struct block_device *);
+extern struct super_block *get_super_exclusive_thawed(struct block_device *bdev);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern void drop_super(struct super_block *sb);
+extern void drop_super_exclusive(struct super_block *sb);
 extern void iterate_supers(void (*)(struct super_block *, void *), void *);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
-- 
2.6.6
