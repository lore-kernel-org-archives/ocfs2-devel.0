From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 22 Apr 2010 16:11:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in
	ocfs2_symlink error path
Message-ID: <201004221611.25402.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

mark the inode with flag OCFS2_INODE_SKIP_ORPHAN_DIR when we meet
an error after allocating one, so that we can kill the inode.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b2a8ed5..4ce4416 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1809,6 +1809,7 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
+		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
 	}
-- 
1.6.4.2
