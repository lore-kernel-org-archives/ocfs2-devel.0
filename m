From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:14 -0800
Subject: [Ocfs2-devel] [patch 03/11] ocfs2: move some definitions to header
	file
Message-ID: <5a20850e.o9gE6SVbz9UP6W49%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: move some definitions to header file

Patch series "ocfs2: use kobject for online file check", v3.

Use embedded kobject mechanism for online file check feature, this will
avoid to use a global list to save/search per-device online file check
related data.  The changed code is based on Goldwyn Rodrigues's patches
and ext4 fs code, there is not any new features added, except some very
small fixes during this code refactoring.  Second, the code change does
not affect the underlying file check code.  Thank Goldwyn very much.

Compare with second version, add more comments in the patch descriptions,
to make sure each modification is mentioned.  Compare with first version,
split the code change into four patches, make sure each patch will not
bring ocfs2 kernel modules compiling errors.


This patch (of 3):

Move some definitions to header file, which will be referenced by other
source files when kobject mechanism is introduced.

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495611866-2D27360-2D2-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=X_q4tNbiBNICvLHoJOYw1UwObhEKDqrcmLfT8-2MjWQ&s=ToS9Ss-UoWIft7TT34_M_AEmAX1GGWHTzYhLaHz-JS4&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   27 ---------------------------
 fs/ocfs2/filecheck.h |   27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-move-some-definitions-to-header-file fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-move-some-definitions-to-header-file
+++ a/fs/ocfs2/filecheck.c
@@ -56,33 +56,6 @@ static const char * const ocfs2_filechec
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
diff -puN fs/ocfs2/filecheck.h~ocfs2-move-some-definitions-to-header-file fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-move-some-definitions-to-header-file
+++ a/fs/ocfs2/filecheck.h
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
 
_
