From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Nov 2013 17:05:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: drop the unwanted null byte in dentry
	lock name
Message-ID: <5295B5BC.5020905@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dentry lock name is made up of the type 'N', the parent blkno and its
blkno represented as a binary value.
Now there is a null byte between parent blkno and the binary blkno
value, so drop it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 2 +-
 fs/ocfs2/dlmglue.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e33cd7a..2d85dfa 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -257,7 +257,7 @@ static int stringify_lockname(const char *lockname, int locklen, char *buf,
 #define OCFS2_DENTRY_LOCK_INO_START	18
 	if (*lockname == 'N') {
 		memcpy((__be64 *)&inode_blkno_be,
-		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START],
+		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START - 1],
 		       sizeof(__be64));
 		out += snprintf(buf + out, len - out, "%.*s%08x",
 				OCFS2_DENTRY_LOCK_INO_START - 1, lockname,
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3a44a64..62f2387 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -586,7 +586,7 @@ static __u64 ocfs2_get_dentry_lock_ino(struct ocfs2_lock_res *lockres)
 {
 	__be64 inode_blkno_be;
 
-	memcpy(&inode_blkno_be, &lockres->l_name[OCFS2_DENTRY_LOCK_INO_START],
+	memcpy(&inode_blkno_be, &lockres->l_name[OCFS2_DENTRY_LOCK_INO_START - 1],
 	       sizeof(__be64));
 
 	return be64_to_cpu(inode_blkno_be);
@@ -631,7 +631,7 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 
 	BUG_ON(len != (OCFS2_DENTRY_LOCK_INO_START - 1));
 
-	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
+	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START - 1], &inode_blkno_be,
 	       sizeof(__be64));
 
 	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
-- 
1.8.4.3
