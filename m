From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Feb 2014 16:18:26 +0100
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: Remove OCFS2_INODE_SKIP_DELETE flag
In-Reply-To: <1392909511-2933-1-git-send-email-jack@suse.cz>
References: <1392909511-2933-1-git-send-email-jack@suse.cz>
Message-ID: <1392909511-2933-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The flag was never set, delete it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.c   | 6 ------
 fs/ocfs2/inode.h   | 8 +++-----
 fs/ocfs2/journal.c | 6 ------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f29a90fde619..b4baaefe4dd4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -822,12 +822,6 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 		goto bail_unlock;
 	}
 
-	/* If we have allowd wipe of this inode for another node, it
-	 * will be marked here so we can safely skip it. Recovery will
-	 * cleanup any inodes we might inadvertently skip here. */
-	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE)
-		goto bail_unlock;
-
 	ret = 1;
 bail_unlock:
 	spin_unlock(&oi->ip_lock);
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 621fc73bf23d..f60bc314ee0a 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -84,8 +84,6 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_BITMAP		0x00000004
 /* This inode has been wiped from disk */
 #define OCFS2_INODE_DELETED		0x00000008
-/* Another node is deleting, so our delete is a nop */
-#define OCFS2_INODE_SKIP_DELETE		0x00000010
 /* Has the inode been orphaned on another node?
  *
  * This hints to ocfs2_drop_inode that it should clear i_nlink before
@@ -100,11 +98,11 @@ struct ocfs2_inode_info
  * rely on ocfs2_delete_inode to sort things out under the proper
  * cluster locks.
  */
-#define OCFS2_INODE_MAYBE_ORPHANED	0x00000020
+#define OCFS2_INODE_MAYBE_ORPHANED	0x00000010
 /* Does someone have the file open O_DIRECT */
-#define OCFS2_INODE_OPEN_DIRECT		0x00000040
+#define OCFS2_INODE_OPEN_DIRECT		0x00000020
 /* Tell the inode wipe code it's not in orphan dir */
-#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000080
+#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000040
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 44fc3e530c3d..03ea9314fecd 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2132,12 +2132,6 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		iter = oi->ip_next_orphan;
 
 		spin_lock(&oi->ip_lock);
-		/* The remote delete code may have set these on the
-		 * assumption that the other node would wipe them
-		 * successfully.  If they are still in the node's
-		 * orphan dir, we need to reset that state. */
-		oi->ip_flags &= ~(OCFS2_INODE_DELETED|OCFS2_INODE_SKIP_DELETE);
-
 		/* Set the proper information to get us going into
 		 * ocfs2_delete_inode. */
 		oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
-- 
1.8.1.4
