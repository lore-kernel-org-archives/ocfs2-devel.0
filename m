From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 10 Apr 2009 13:34:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add NFS Sync lock type string.
Message-ID: <200904100535.n3A5ZaEm026946@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The lock type string for NFS Sync lock is missing from the last patch
http://oss.oracle.com/pipermail/ocfs2-devel/2009-March/004117.html

This patch is to add the lock type string.
This patch also applies to 1.4 git.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index a53ce87..e95cc7b 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -104,6 +104,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_OPEN] = "Open",
 	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
 	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
+	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFS_Sync",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
