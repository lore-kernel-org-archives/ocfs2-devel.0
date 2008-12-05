From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  5 Dec 2008 09:14:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Always update xattr search when
	creating bucket.
Message-ID: <1228439650-5101-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we create xattr bucket during the process of xattr set, we always
need to update the ocfs2_xattr_search since even if the bucket size is
the same as block size, the offset will change because of the removal
of the ocfs2_xattr_block header.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 054e2ef..74d7367 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2645,9 +2645,9 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 				return ret;
 			}
 
-			i = xs->here - old_xh->xh_entries;
-			xs->here = &xs->header->xh_entries[i];
 		}
+		i = xs->here - old_xh->xh_entries;
+		xs->here = &xs->header->xh_entries[i];
 	}
 
 	return ret;
-- 
1.5.4.GIT
