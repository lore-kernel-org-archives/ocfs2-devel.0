From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 13 Nov 2010 16:22:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Change some lock status member in
	ocfs2_lock_res to char.
Message-ID: <1289636522-3081-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 83fd9c7 changes l_level, l_requested and l_blocking of
ocfs2_lock_res from int to unsigned char. But actually it is
initially as -1(ocfs2_lock_res_init_common) which
correspoding to 255 for unsigned char. So the whole dlm lock
mechanism doesn't work now which means a disaster to ocfs2.

Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d840821..1efea36 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -159,7 +159,9 @@ struct ocfs2_lock_res {
 	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
 	unsigned int             l_ro_holders;
 	unsigned int             l_ex_holders;
-	unsigned char            l_level;
+	char			 l_level;
+	char			 l_requested;
+	char			 l_blocking;
 
 	/* Data packed - type enum ocfs2_lock_type */
 	unsigned char            l_type;
@@ -169,8 +171,6 @@ struct ocfs2_lock_res {
 	unsigned char            l_action;
 	/* Data packed - enum type ocfs2_unlock_action */
 	unsigned char            l_unlock_action;
-	unsigned char            l_requested;
-	unsigned char            l_blocking;
 	unsigned int             l_pending_gen;
 
 	spinlock_t               l_lock;
-- 
1.7.2.1
