From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 19 Mar 2010 09:21:10 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of reflinked
	oprhan inodes correctly.
In-Reply-To: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1268961670-4712-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current rule of orphan dir is that all inodes in the orphan dir
have ORPHANED_FL, otherwise we treated it as an ERROR. this rule
works well except for some rare cases of reflink operation:

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1215

The problem is introduced by the essense of how reflink and our
orphan_scan thread were working:

 * Orphan_scan scan the orphan dir into a queue first, and run
   queue in a later time, we only hold the orphan_dir's lock
   during scanning.

 * Reflink create a oprhaned target in orphan_dir at the first
   step, and remove the targets and unset the flag at the third
   step, these two steps respectively hold the orphan_dir's lock
   themselves.

Based on above semantics, there is a possibility that a reflink
inode can be moved out of the orphan dir and have its ORPHANED_FL
cleared before the queue is run, which leads to a ERROR in
ocfs2_query_wipde_inode().

This patch helps to judge if a orphan inode to be wiped off, which
has NO ORPHANED_FL, is a legal alive reflinked target or not.

The patch also works for failed reflinked targets from a crash or
other failures during the reflink operation, they can be wiped off
as desired since these failed reflinked inodes always has ORPHANED_FL
set ondisk.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/inode.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 88459bd..be27e72 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -891,6 +891,21 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	/* Do some basic inode verification... */
 	di = (struct ocfs2_dinode *) di_bh->b_data;
 	if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
+		/*
+		 * Inodes in the orphan dir must have ORPHANED_FL.  The only
+		 * inodes that come back out of the orphan dir are reflink
+		 * targets. A reflink target may be moved out of the orphan
+		 * dir between the time we scan the directory and the time we
+		 * process it. This would lead to HAS_REFCOUNT_FL being set but
+		 * ORPHANED_FL not.
+		 */
+		if (di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) {
+			mlog(0, "Reflinked inode %llu is no longer orphaned.  "
+			     "it shouldn't be deleted\n",
+			     (unsigned long long)oi->ip_blkno);
+			goto bail;
+		}
+
 		/* for lack of a better error? */
 		status = -EEXIST;
 		mlog(ML_ERROR,
-- 
1.5.5
