From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 26 May 2011 17:57:10 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Add hard readonly check in open
	lock
In-Reply-To: <4DDE2000.3000301@oracle.com>
References: <4DDE2000.3000301@oracle.com>
Message-ID: <1306403830-15266-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As no dlm lock in hard readonly mount, so add hard readonly check
in open lock, otherwise ocfs2_cluster_lock leads to oops.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/dlmglue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..09e8b30 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1692,7 +1692,7 @@ int ocfs2_open_lock(struct inode *inode)
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
 		goto out;
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
@@ -1718,6 +1718,12 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
 
+	if (ocfs2_is_hard_readonly(osb)) {
+		if (write)
+			status = -EROFS;
+		goto out;
+	}
+
 	if (ocfs2_mount_local(osb))
 		goto out;
 
-- 
1.7.4.4
