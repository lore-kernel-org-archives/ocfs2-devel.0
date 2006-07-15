From: Adrian Bunk <bunk@stusta.de>
Date: Sat, 15 Jul 2006 02:36:01 +0200
Subject: [Ocfs2-devel] [RFC: 2.6 patch] fs/ocfs2/dlm/dlmmaster.c: unexport
	dlm_migrate_lockres
Message-ID: <20060715003600.GK3633@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch removes the unused EXPORT_SYMBOL_GPL(dlm_migrate_lockres).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc1-mm2-full/fs/ocfs2/dlm/dlmmaster.c.old	2006-07-15 00:40:56.000000000 +0200
+++ linux-2.6.18-rc1-mm2-full/fs/ocfs2/dlm/dlmmaster.c	2006-07-15 00:41:07.000000000 +0200
@@ -2375,7 +2375,6 @@
 	mlog(0, "returning %d\n", ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dlm_migrate_lockres);
 
 int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
