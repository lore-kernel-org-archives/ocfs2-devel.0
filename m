From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 19 Sep 2008 22:16:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Fix a bug when inserting xattr.
Message-ID: <1221833794-15198-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During the process of xatt insertion, we use binary search
to find the right place and "low" is set to it. But when
there is one xattr which has the same name hash as the inserted
one, low is the wrong value. So set it to the right position.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e65c8ac..584aef8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4029,8 +4029,10 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 			else if (name_hash <
 				 le32_to_cpu(tmp_xe->xe_name_hash))
 				high = tmp - 1;
-			else
+			else {
+				low = tmp;
 				break;
+			}
 		}
 
 		xe = &xh->xh_entries[low];
-- 
1.5.4.GIT
