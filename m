From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Sat, 31 Jan 2015 12:05:24 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove goto statement in
	ocfs2_dx_dir_link_trailer()
Message-ID: <20150131030524.GA6753@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

It is nothing to do in 'out' label, so just return 'ret'
variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 319e786..e6e5de8 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -179,7 +179,7 @@ static int ocfs2_dx_dir_link_trailer(struct inode *dir, handle_t *handle,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 	trailer = ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
@@ -189,7 +189,6 @@ static int ocfs2_dx_dir_link_trailer(struct inode *dir, handle_t *handle,
 
 	ocfs2_journal_dirty(handle, dx_root_bh);
 
-out:
 	return ret;
 }
 
-- 
1.7.1
