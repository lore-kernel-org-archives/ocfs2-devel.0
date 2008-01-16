From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:16 2008
Subject: [Ocfs2-devel] [PATCH 13/20] ocfs2: Remove bug statement in
	ocfs2_dentry_iput()
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-14-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit bccb9dad8949cd0df1d3d2188a1fdb4b1936d537
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 7 Nov 2007 16:35:14 -0800

The existing bug statement didn't take into account unhashed dentries which
might not have a cluster lock on them. This could happen if a node exporting
the file system via NFS is rebooted, re-exported to nfs clients and then
unmounted. It's fine in this case to not have a dentry cluster lock.

Just remove the bug statement and replace it with an error print, which
does the proper checks. Though we want to know if something has happened
which might have prevented a cluster lock from being created, it's
definitely not necessary to panic the machine for this.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dcache.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 9e76e3c..6ec9556 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -344,12 +344,24 @@ static void ocfs2_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 
-	mlog_bug_on_msg(!dl && !(dentry->d_flags & DCACHE_DISCONNECTED),
-			"dentry: %.*s\n", dentry->d_name.len,
-			dentry->d_name.name);
+	if (!dl) {
+		/*
+		 * No dentry lock is ok if we're disconnected or
+		 * unhashed.
+		 */
+		if (!(dentry->d_flags & DCACHE_DISCONNECTED) &&
+		    !d_unhashed(dentry)) {
+			unsigned long long ino = 0ULL;
+			if (inode)
+				ino = (unsigned long long)OCFS2_I(inode)->ip_blkno;
+			mlog(ML_ERROR, "Dentry is missing cluster lock. "
+			     "inode: %llu, d_flags: 0x%x, d_name: %.*s\n",
+			     ino, dentry->d_flags, dentry->d_name.len,
+			     dentry->d_name.name);
+		}
 
-	if (!dl)
 		goto out;
+	}
 
 	mlog_bug_on_msg(dl->dl_count == 0, "dentry: %.*s, count: %u\n",
 			dentry->d_name.len, dentry->d_name.name,
-- 
1.5.3.4
