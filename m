From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat,  1 Oct 2016 16:41:38 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: Replace CURRENT_TIME macro
Message-ID: <1475365298-29236-1-git-send-email-deepa.kernel@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

CURRENT_TIME is not y2038 safe.

Use y2038 safe ktime_get_real_seconds() here for timestamps.
struct heartbeat_block's hb_seq and deletetion time are already
64 bits wide and accommodate times beyond y2038.

Also use y2038 safe ktime_get_real_ts64() for on disk inode
timestamps.
These are also wide enough to accommodate time64_t.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 fs/ocfs2/inode.c             | 2 +-
 fs/ocfs2/namei.c             | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 636abcb..9158c98 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -741,7 +741,7 @@ static inline void o2hb_prepare_block(struct o2hb_region *reg,
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
 	memset(hb_block, 0, reg->hr_block_bytes);
 	/* TODO: time stuff */
-	cputime = CURRENT_TIME.tv_sec;
+	cputime = ktime_get_real_seconds();
 	if (!cputime)
 		cputime = 1;
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c56a767..382401d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -703,7 +703,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail_commit;
 	}
 
-	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
+	di->i_dtime = cpu_to_le64(ktime_get_real_seconds());
 	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a8f1225..e96ed24 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -516,6 +516,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	struct ocfs2_extent_list *fel;
 	u16 feat;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct timespec64 ts;
 
 	*new_fe_bh = NULL;
 
@@ -564,10 +565,11 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
+	ktime_get_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
-		cpu_to_le64(CURRENT_TIME.tv_sec);
+		cpu_to_le64(ts.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
-		cpu_to_le32(CURRENT_TIME.tv_nsec);
+		cpu_to_le32(ts.tv_nsec);
 	fe->i_dtime = 0;
 
 	/*
-- 
2.7.4
