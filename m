From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Dec 2014 16:37:17 +0100
Subject: [Ocfs2-devel] [PATCH 03/25] xfs: Remove some useless flags tests
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
Message-ID: <1418917059-23870-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

'flags' have XFS_ALL_QUOTA_ACCT cleared immediately on function entry.
There's no point in checking these bits later in the function. Also
because we check something is going to change, we know some enforcement
bits are being added and thus there's no point in testing that later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 28f55fa13831..528c1cee430f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -327,22 +327,16 @@ xfs_qm_scall_quotaon(
 		return -EINVAL;
 	}
 
-	/* No fs can turn on quotas with a delayed effect */
-	ASSERT((flags & XFS_ALL_QUOTA_ACCT) == 0);
-
 	/*
 	 * Can't enforce without accounting. We check the superblock
 	 * qflags here instead of m_qflags because rootfs can have
 	 * quota acct on ondisk without m_qflags' knowing.
 	 */
-	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
+	if (((mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
 	     (flags & XFS_UQUOTA_ENFD)) ||
-	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
+	    ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
 	     (flags & XFS_GQUOTA_ENFD)) ||
-	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
+	    ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
 	     (flags & XFS_PQUOTA_ENFD))) {
 		xfs_debug(mp,
 			"%s: Can't enforce without acct, flags=%x sbflags=%x",
@@ -380,8 +374,7 @@ xfs_qm_scall_quotaon(
 	     ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) !=
 	     (mp->m_qflags & XFS_PQUOTA_ACCT)) ||
 	     ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) !=
-	     (mp->m_qflags & XFS_GQUOTA_ACCT)) ||
-	    (flags & XFS_ALL_QUOTA_ENFD) == 0)
+	     (mp->m_qflags & XFS_GQUOTA_ACCT)))
 		return 0;
 
 	if (! XFS_IS_QUOTA_RUNNING(mp))
-- 
1.8.4.5
