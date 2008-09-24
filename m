From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:01:15 -0700
Subject: [Ocfs2-devel] [PATCH 34/39] ocfs2: bug-fix for journal extend in
	xattr.
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-35-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

In ocfs2_extend_trans, when we can't extend the current
transaction, it will commit current transaction and restart
a new one. So if the previous credits we have allocated aren't
used(the block isn't dirtied before our extend), we will not
have enough credits for any future operation(it will cause jbd
complain and bug out). So check this and re-extend it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1a4de3d..38e3e5e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1336,8 +1336,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		/*set extended attribue in external blcok*/
+		/* set extended attribute in external block. */
 		ret = ocfs2_extend_trans(handle,
+					 OCFS2_INODE_UPDATE_CREDITS +
 					 OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
 		if (ret) {
 			mlog_errno(ret);
@@ -3701,6 +3702,18 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 
+	if (handle->h_buffer_credits < credits) {
+		/*
+		 * The journal has been restarted before, and don't
+		 * have enough space for the insertion, so extend it
+		 * here.
+		 */
+		ret = ocfs2_extend_trans(handle, credits);
+		if (ret) {
+			mlog_errno(ret);
+			goto leave;
+		}
+	}
 	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
-- 
1.5.4.5
