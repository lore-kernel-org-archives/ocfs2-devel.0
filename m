From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 21 Jan 2010 10:50:02 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix setting of OCFS2_LOCK_BLOCKED
	during bast
In-Reply-To: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1264099803-16680-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>

During bast, set the OCFS2_LOCK_BLOCKED flag only if the lock needs to
downconverted.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Acked-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0d38d67..0190f31 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -907,8 +907,6 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 
 	assert_spin_locked(&lockres->l_lock);
 
-	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
-
 	if (level > lockres->l_blocking) {
 		/* only schedule a downconvert if we haven't already scheduled
 		 * one that goes low enough to satisfy the level we're
@@ -921,6 +919,9 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 		lockres->l_blocking = level;
 	}
 
+	if (needs_downconvert)
+		lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
+		
 	mlog_exit(needs_downconvert);
 	return needs_downconvert;
 }
-- 
1.6.3.3
