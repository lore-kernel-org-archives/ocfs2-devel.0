From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] fix OCFS_FE_SET_ATTRIBUTES mess
Message-ID: <20040602095836.GA24046@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/file.c
===================================================================
--- src/file.c	(revision 969)
+++ src/file.c	(working copy)
@@ -42,39 +42,27 @@
 static int ocfs_truncate_file (ocfs_super * osb, __u64 file_off, __u64 file_size, struct inode *inode);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#define OCFS_FE_SET_ATTRIBUTES(fe, attr) 				     \
-do {									     \
-	if (attr->ia_valid & ATTR_SIZE)					     \
-		fe->file_size = attr->ia_size;				     \
-	if (attr->ia_valid & ATTR_UID)					     \
-		fe->uid = attr->ia_uid;					     \
-	if (attr->ia_valid & ATTR_GID)					     \
-		fe->gid = attr->ia_gid;					     \
-	if (attr->ia_valid & ATTR_MODE)					     \
-		fe->prot_bits = attr->ia_mode & 0007777;		     \
-	if (attr->ia_valid & ATTR_CTIME)				     \
-		fe->create_time = attr->ia_ctime.tv_sec;		     \
-	if (attr->ia_valid & ATTR_MTIME)				     \
-		fe->modify_time = attr->ia_mtime.tv_sec;		     \
-} while (0)
-#else /* 2.4 kernel */
-#define OCFS_FE_SET_ATTRIBUTES(fe, attr) 				     \
-do {									     \
-	if (attr->ia_valid & ATTR_SIZE)					     \
-		fe->file_size = attr->ia_size;				     \
-	if (attr->ia_valid & ATTR_UID)					     \
-		fe->uid = attr->ia_uid;					     \
-	if (attr->ia_valid & ATTR_GID)					     \
-		fe->gid = attr->ia_gid;					     \
-	if (attr->ia_valid & ATTR_MODE)					     \
-		fe->prot_bits = attr->ia_mode & 0007777;		     \
-	if (attr->ia_valid & ATTR_CTIME)				     \
-		fe->create_time = attr->ia_ctime;			     \
-	if (attr->ia_valid & ATTR_MTIME)				     \
-		fe->modify_time = attr->ia_mtime;			     \
-} while (0)
+#define ocfs_get_seconds(t)	(t).tv_sec
+#else
+#define ocfs_get_seconds(t)	(t)
 #endif
 
+static void ocfs_fe_set_attributes(ocfs_file_entry *fe, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_SIZE)
+		fe->file_size = attr->ia_size;
+	if (attr->ia_valid & ATTR_UID)
+		fe->uid = attr->ia_uid;
+	if (attr->ia_valid & ATTR_GID)
+		fe->gid = attr->ia_gid;
+	if (attr->ia_valid & ATTR_MODE)
+		fe->prot_bits = attr->ia_mode & 0007777;
+	if (attr->ia_valid & ATTR_CTIME)
+		fe->create_time = ocfs_get_seconds(attr->ia_ctime);
+	if (attr->ia_valid & ATTR_MTIME)
+		fe->modify_time = ocfs_get_seconds(attr->ia_mtime);
+}
+
 static inline int ocfs_sync_inode(struct inode *inode)
 {
 	int status;
@@ -659,7 +647,7 @@
 	fileEntry->modify_time = OCFS_CURRENT_TIME;
 
 	DISK_LOCK_SEQNUM (fileEntry) = 0;
-	OCFS_FE_SET_ATTRIBUTES(fileEntry, attr);
+	ocfs_fe_set_attributes(fileEntry, attr);
 
 	/* Set the valid bit here */
 	SET_VALID_BIT (fileEntry->sync_flags);
@@ -1287,7 +1275,7 @@
 	LOG_TRACE_ARGS("fileEntry->alloc_size = %llu\n", fileEntry->alloc_size);
 
 	if (attr)
-		OCFS_FE_SET_ATTRIBUTES(fileEntry, attr);
+		ocfs_fe_set_attributes(fileEntry, attr);
 	/* Set the Valid bit and reset the change bit here... TODO */
 	SET_VALID_BIT (fileEntry->sync_flags);
 	fileEntry->sync_flags &= ~(OCFS_SYNC_FLAG_CHANGE);
