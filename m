From: Coly Li <coly.li@suse.de>
Date: Fri, 28 Aug 2009 19:03:18 +0800
Subject: [Ocfs2-devel] [PATCH] dlmglue.c: add missed mlog lines
Message-ID: <4A97B976.4030506@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds the missed mlog_exit() and mlog_exit_void() lines when routines
return.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/dlmglue.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 110bb57..90df30d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1548,8 +1548,10 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");

-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb)) {
+		mlog_exit(0);
 		return 0;
+	}

 	lockres = &OCFS2_I(inode)->ip_rw_lockres;

@@ -3009,6 +3011,7 @@ static void ocfs2_unlock_ast(void *opaque, int error)
 		     "unlock_action %d\n", error, lockres->l_name,
 		     lockres->l_unlock_action);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		mlog_exit_void();
 		return;
 	}


-- 
Coly Li
SuSE Labs
