From: Tao Ma <tm@tao.ma>
Date: Wed, 22 Dec 2010 17:50:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix system inodes cache overflow.
Message-ID: <1293011430-2376-1-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

When we store system inodes cache in ocfs2_super,
we use a array for global system inodes. But unfortunately,
the range is calculated wrongly which makes it overflow and
pollute ocfs2_super->local_system_inodes.
This patch fix it by setting the range properly.

The corresponding bug is ossbug1303.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1303

Cc: stable at kernel.org
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c2e4f82..bf2e776 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -350,7 +350,7 @@ enum {
 #define OCFS2_LAST_LOCAL_SYSTEM_INODE LOCAL_GROUP_QUOTA_SYSTEM_INODE
 	NUM_SYSTEM_INODES
 };
-#define NUM_GLOBAL_SYSTEM_INODES OCFS2_LAST_GLOBAL_SYSTEM_INODE
+#define NUM_GLOBAL_SYSTEM_INODES OCFS2_FIRST_LOCAL_SYSTEM_INODE
 #define NUM_LOCAL_SYSTEM_INODES	\
 		(NUM_SYSTEM_INODES - OCFS2_FIRST_LOCAL_SYSTEM_INODE)
 
-- 
1.6.3.GIT
