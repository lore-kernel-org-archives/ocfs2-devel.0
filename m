From: Gang He <ghe@suse.com>
Date: Wed, 21 Dec 2016 16:20:58 +0800
Subject: [Ocfs2-devel] [PATCH v2 1/4] ocfs2: move some definitions to header
	file
In-Reply-To: <1482308461-12964-1-git-send-email-ghe@suse.com>
References: <1482308461-12964-1-git-send-email-ghe@suse.com>
Message-ID: <1482308461-12964-2-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Move some definitions to header file, which will be referenced
by other source files when kobject mechanism is introduced.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/filecheck.c | 27 ---------------------------
 fs/ocfs2/filecheck.h | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 2cabbcf..cc7b595 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -56,33 +56,6 @@
 static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
 static LIST_HEAD(ocfs2_filecheck_sysfs_list);
 
-struct ocfs2_filecheck {
-	struct list_head fc_head;	/* File check entry list head */
-	spinlock_t fc_lock;
-	unsigned int fc_max;	/* Maximum number of entry in list */
-	unsigned int fc_size;	/* Current entry count in list */
-	unsigned int fc_done;	/* Finished entry count in list */
-};
-
-struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
-	struct list_head fs_list;
-	atomic_t fs_count;
-	struct super_block *fs_sb;
-	struct kset *fs_devicekset;
-	struct kset *fs_fcheckkset;
-	struct ocfs2_filecheck *fs_fcheck;
-};
-
-#define OCFS2_FILECHECK_MAXSIZE		100
-#define OCFS2_FILECHECK_MINSIZE		10
-
-/* File check operation type */
-enum {
-	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
-	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
-	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
-};
-
 struct ocfs2_filecheck_entry {
 	struct list_head fe_list;
 	unsigned long fe_ino;
diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
index e5cd002..af1678b 100644
--- a/fs/ocfs2/filecheck.h
+++ b/fs/ocfs2/filecheck.h
@@ -43,6 +43,33 @@ enum {
 #define OCFS2_FILECHECK_ERR_START	OCFS2_FILECHECK_ERR_FAILED
 #define OCFS2_FILECHECK_ERR_END		OCFS2_FILECHECK_ERR_UNSUPPORTED
 
+struct ocfs2_filecheck {
+	struct list_head fc_head;	/* File check entry list head */
+	spinlock_t fc_lock;
+	unsigned int fc_max;	/* Maximum number of entry in list */
+	unsigned int fc_size;	/* Current entry count in list */
+	unsigned int fc_done;	/* Finished entry count in list */
+};
+
+struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
+	struct list_head fs_list;
+	atomic_t fs_count;
+	struct super_block *fs_sb;
+	struct kset *fs_devicekset;
+	struct kset *fs_fcheckkset;
+	struct ocfs2_filecheck *fs_fcheck;
+};
+
+#define OCFS2_FILECHECK_MAXSIZE		100
+#define OCFS2_FILECHECK_MINSIZE		10
+
+/* File check operation type */
+enum {
+	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
+	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
+	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
+};
+
 int ocfs2_filecheck_create_sysfs(struct super_block *sb);
 int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
 
-- 
1.8.5.6
