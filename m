From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:29 -0800
Subject: [Ocfs2-devel] [PATCH 14/35] ocfs2: Pass value buf to
	ocfs2_xattr_update_entry().
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-15-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2_xattr_update_entry() updates the entry portion of an xattr buffer.
This can be part of multiple metadata block types, so pass the buffer in
via an ocfs2_xattr_value_buf.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 409f9ee..6a05612 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1282,12 +1282,13 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 				    handle_t *handle,
 				    struct ocfs2_xattr_info *xi,
 				    struct ocfs2_xattr_search *xs,
+				    struct ocfs2_xattr_value_buf *vb,
 				    size_t offs)
 {
 	int ret;
 
-	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = vb->vb_access(handle, inode, vb->vb_bh,
+			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1301,7 +1302,7 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 		ocfs2_xattr_set_local(xs->here, 0);
 	ocfs2_xattr_hash_entry(inode, xs->header, xs->here);
 
-	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
+	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
 	if (ret < 0)
 		mlog_errno(ret);
 out:
@@ -1345,7 +1346,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, offs);
+	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, &vb, offs);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1574,6 +1575,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 							       handle,
 							       xi,
 							       xs,
+							       &vb,
 							       offs);
 				if (ret < 0) {
 					mlog_errno(ret);
-- 
1.5.6
