From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed,  4 Mar 2009 11:21:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for directory
	inode in mknod
In-Reply-To: <49ADF2FB.6060503@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
Message-ID: <1236136873-3980-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As we set directory inode starting with inline data,
there is no place in inode for ACLs or security extended
attributes entries. In this case, we have to reserve
xattr block at the begining of mknod.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4ddd788..053ae3d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -549,6 +549,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 	 * for them is ok.
 	 */
 	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
+	    (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) ||
 	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
 		if (ret) {
-- 
1.5.4.1
