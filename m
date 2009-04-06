From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  7 Apr 2009 07:40:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reserve 1 more cluster in
	expanding_inline_dir for indexed dir.
Message-ID: <1239061257-27065-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_expand_inline_dir, we calculate whether we need 1 extra
cluster if we can't store the dx inline the root and save it in
dx_alloc. So add it when we call ocfs2_reserve_clusters.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e71160c..07d8920 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2934,7 +2934,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 */
 	BUG_ON(alloc > 2);
 
-	ret = ocfs2_reserve_clusters(osb, alloc, &data_ac);
+	ret = ocfs2_reserve_clusters(osb, alloc + dx_alloc, &data_ac);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
1.6.1.40.g8ea6a
