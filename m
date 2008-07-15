From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 14 Jul 2008 17:31:09 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Adds counter in struct
	ocfs2_dinode to track journal replays
In-Reply-To: <1216081870-20256-1-git-send-email-sunil.mushran@oracle.com>
References: <1216081870-20256-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1216081870-20256-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch renames the ij_pad to ij_recovery_generation in struct ocfs2_dinode.
This will be used to keep count of journal replays after an unclean shutdown.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 52c4266..a5e0890 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -660,7 +660,10 @@ struct ocfs2_dinode {
 		struct {		/* Info for journal system
 					   inodes */
 			__le32 ij_flags;	/* Mounted, version, etc. */
-			__le32 ij_pad;
+			__le32 ij_recovery_generation; /* Incremented when the
+							  journal is recovered
+							  after an unclean
+							  shutdown */
 		} journal1;
 	} id1;				/* Inode type dependant 1 */
 /*C0*/	union {
-- 
1.5.4.5
