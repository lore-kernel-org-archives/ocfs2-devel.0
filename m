From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 12 Oct 2010 11:18:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Avoid to evaluate xattr block
	flags again.
In-Reply-To: <>
References: <>
Message-ID: <1286853498-8193-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It was evaludated to indexed before, check it is ok i think.

Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e97b348..1e51eb4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7011,7 +7011,7 @@ static int ocfs2_reflink_xattr_in_block(struct ocfs2_xattr_reflink *args,
 		goto out;
 	}
 
-	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED))
+	if (!indexed)
 		ret = ocfs2_reflink_xattr_block(args, blk_bh, new_blk_bh);
 	else
 		ret = ocfs2_reflink_xattr_tree(args, blk_bh, new_blk_bh);
-- 
1.5.4.3
