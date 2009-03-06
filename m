From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri,  6 Mar 2009 10:19:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for new
	directory with inline data
In-Reply-To: <20090305233027.GB27682@mail.oracle.com>
References: <20090305233027.GB27682@mail.oracle.com>
Message-ID: <1236305970-3940-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If this is a new directory with inline data, we choose to
reserve the entire inline area for directory contents and
force an external xattr block.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4ddd788..c63efb5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -547,8 +547,12 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 	 * when blocksize = 512, may reserve one more cluser for
 	 * xattr bucket, otherwise reserve one metadata block
 	 * for them is ok.
+	 * If this is a new directory with inline data,
+	 * we choose to reserve the entire inline area for
+	 * directory contents and force an external xattr block.
 	 */
 	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
+	    (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) ||
 	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
 		if (ret) {
-- 
1.5.4.1
