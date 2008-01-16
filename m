From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:04 2008
Subject: [Ocfs2-devel] [PATCH 11/20] ocfs2: log valid inode # on bad inode
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit a46043e08f300982c51df317e2f8fb919dedadcd
Author: Mark Fasheh <mfasheh@ca-build8.us.oracle.com>
Date: Mon, 19 Nov 2007 18:40:16 -0800

If the inode block isn't valid then we don't want to print the value from
that, instead print the block number which was passed in (which should
always be correct). Also, turn this into a debug print for now - folks who
hit an actual problem always have other logs indicating what the source is.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9e3e7df..ebb2bbe 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -455,8 +455,8 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	status = -EINVAL;
 	fe = (struct ocfs2_dinode *) bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		mlog(ML_ERROR, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
+		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
+		     (unsigned long long)args->fi_blkno, 7,
 		     fe->i_signature);
 		goto bail;
 	}
-- 
1.5.3.4
