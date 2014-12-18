From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Dec 2014 16:37:16 +0100
Subject: [Ocfs2-devel] [PATCH 02/25] xfs: Remove unused variable in
	xfs_qm_scall_quotaon()
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
Message-ID: <1418917059-23870-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

sbflags variable in xfs_qm_scall_quotaon() was practically unused (we
only set it to constant at one place and used it elsewhere). Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 74fca68e43b6..28f55fa13831 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -314,7 +314,6 @@ xfs_qm_scall_quotaon(
 {
 	int		error;
 	uint		qf;
-	__int64_t	sbflags;
 
 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 	/*
@@ -322,8 +321,6 @@ xfs_qm_scall_quotaon(
 	 */
 	flags &= ~(XFS_ALL_QUOTA_ACCT);
 
-	sbflags = 0;
-
 	if (flags == 0) {
 		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
 			__func__, mp->m_qflags);
@@ -370,11 +367,10 @@ xfs_qm_scall_quotaon(
 	/*
 	 * There's nothing to change if it's the same.
 	 */
-	if ((qf & flags) == flags && sbflags == 0)
+	if ((qf & flags) == flags)
 		return -EEXIST;
-	sbflags |= XFS_SB_QFLAGS;
 
-	if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
+	if ((error = xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)))
 		return error;
 	/*
 	 * If we aren't trying to switch on quota enforcement, we are done.
-- 
1.8.4.5
