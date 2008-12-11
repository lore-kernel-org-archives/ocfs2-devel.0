From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 11 Dec 2008 10:39:42 -0800
Subject: [Ocfs2-devel] [PATCH 01/13] ocfs2: Dirty the entire bucket
	in	ocfs2_bucket_value_truncate()
In-Reply-To: <20081127030109.GC6259@mail.oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-2-git-send-email-joel.becker@oracle.com>
	<492DF6A8.4080309@oracle.com>
	<20081127030109.GC6259@mail.oracle.com>
Message-ID: <20081211183942.GA12336@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Wed, Nov 26, 2008 at 07:01:09PM -0800, Joel Becker wrote:
> 	Good point.  Here's an updated version.

	Tristan's testing revealed a bug in the credits calculation in
ocfs2_delete_xattr_in_bucket(), which Tao found the fix for.  oss
bugzilla 1059.  That's been merged into the patch.  
	In addition, Tao added this change which I've added to my
branch.

From a647d0ab5a278b7ddcee5075ef345c40f2783a33 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 11 Dec 2008 08:54:11 +0800
Subject: [PATCH] ocfs2: Narrow the transaction for deleting xattrs from a bucket.

We move the transaction into the loop because in
ocfs2_remove_extent, we will double the credits in function
ocfs2_extend_rotate_transaction. So if we have a large loop
number, we will soon waste much the journal space.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 365b876..93c5668 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5100,30 +5100,30 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(ctxt.handle)) {
-		ret = PTR_ERR(ctxt.handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
+		ctxt.handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(ctxt.handle)) {
+			ret = PTR_ERR(ctxt.handle);
+			mlog_errno(ret);
+			break;
+		}
+
 		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
+
+		ocfs2_commit_trans(osb, ctxt.handle);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
-	ret = ocfs2_commit_trans(osb, ctxt.handle);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
-out:
 	return ret;
 }
 
-- 
1.5.6.5


-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
