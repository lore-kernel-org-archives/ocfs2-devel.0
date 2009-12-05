From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  4 Dec 2009 17:54:04 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: fix sendfile locking
In-Reply-To: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
References: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1259978046-5692-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

ocfs2_sendfile() was duplicating locking which happens later on in
ocfs2_readpage(). The double locking would sometimes cause a lockup in nfsd,
which uses ->sendfile() for fast read support. An easy way to see this is to
mount an exported ocfs2 fs on a client and initiate two parallel read/write
dd commands to the same file when there is low memory on the server.

Fix ocfs2_sendfile() so that it only takes and immediately drops the cluster
lock. This is consistent with the locking in ocfs2_file_splice_read().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/file.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index daba3a6..3a2ba66 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2284,15 +2284,14 @@ static ssize_t ocfs2_file_sendfile(struct file *in_file,
 		mlog_errno(ret);
 		goto bail;
 	}
+	ocfs2_inode_unlock(inode, 0);
 
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-
+	/*
+	 * This uses ->readpage, so we don't want to hold any cluster
+	 * locks before the call.
+	 */
 	ret = generic_file_sendfile(in_file, ppos, count, actor, target);
 
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-	ocfs2_inode_unlock(inode, 0);
-
 bail:
 	mlog_exit(ret);
 	return ret;
-- 
1.6.3.3
