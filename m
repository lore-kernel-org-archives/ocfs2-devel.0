From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 21 Apr 2010 14:05:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update VFS inode's id info after
	reflink.
Message-ID: <1271829955-3994-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In reflink we update the id info in the disk but forget to update
the corresponding information in the VFS inode. So update them
accordingly in case we want to preserve the attributes.

Reported-by: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8ae65c9..a8e8572 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4083,6 +4083,9 @@ static int ocfs2_complete_reflink(struct inode *s_inode,
 	di->i_attr = s_di->i_attr;
 
 	if (preserve) {
+		t_inode->i_uid = s_inode->i_uid;
+		t_inode->i_gid = s_inode->i_gid;
+		t_inode->i_mode = s_inode->i_mode;
 		di->i_uid = s_di->i_uid;
 		di->i_gid = s_di->i_gid;
 		di->i_mode = s_di->i_mode;
-- 
1.6.3.3.334.g916e1.dirty
