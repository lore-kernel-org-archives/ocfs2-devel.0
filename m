From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:54:04 -0800
Subject: [Ocfs2-devel] [PATCH 45/45] ocfs2/xattr: Restore not_found in xis
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-46-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

During an xattr set, when we move a xattr which was stored in inode to the
outside bucket, we have to delete it and it will use the old value of
xis->not_found. xis->not_found is removed by ocfs2_calc_xattr_set_need
though, so we must restore it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d0b94ed..9cb71e1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2414,7 +2414,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				    struct ocfs2_xattr_search *xbs,
 				    struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret = 0, credits;
+	int ret = 0, credits, old_found;
 
 	if (!xi->value) {
 		/* Remove existing extended attribute */
@@ -2433,6 +2433,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 			xi->value = NULL;
 			xi->value_len = 0;
 
+			old_found = xis->not_found;
 			xis->not_found = -ENODATA;
 			ret = ocfs2_calc_xattr_set_need(inode,
 							di,
@@ -2442,6 +2443,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 							NULL,
 							NULL,
 							&credits);
+			xis->not_found = old_found;
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -2462,6 +2464,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				if (ret)
 					goto out;
 
+				old_found = xis->not_found;
 				xis->not_found = -ENODATA;
 				ret = ocfs2_calc_xattr_set_need(inode,
 								di,
@@ -2471,6 +2474,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 								NULL,
 								NULL,
 								&credits);
+				xis->not_found = old_found;
 				if (ret) {
 					mlog_errno(ret);
 					goto out;
-- 
1.5.6
