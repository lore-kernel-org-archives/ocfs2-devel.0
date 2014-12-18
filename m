From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Dec 2014 16:37:15 +0100
Subject: [Ocfs2-devel] [PATCH 01/25] xfs: Remove useless test
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
Message-ID: <1418917059-23870-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 7542bbeca6a1..8fcd20dbf89a 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -75,7 +75,7 @@ xfs_fs_set_xstate(
 
 	if (sb->s_flags & MS_RDONLY)
 		return -EROFS;
-	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
 
 	if (uflags & FS_QUOTA_UDQ_ACCT)
-- 
1.8.4.5
