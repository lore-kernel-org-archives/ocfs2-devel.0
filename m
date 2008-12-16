From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 16 Dec 2008 15:49:21 -0800
Subject: [Ocfs2-devel] [PATCH 7/9] ocfs2/dlm: Hold off sending lockres drop
	ref message while lockres is migrating
In-Reply-To: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1229471363-15887-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During lockres purge, o2dlm sends a drop reference message to the lockres
master. This patch delays the message if the lockres is being migrated.

Fixes oss bugzilla#1012
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1012

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmthread.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 4060bb3..d129520 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -181,7 +181,8 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 
 		spin_lock(&res->spinlock);
 		/* This ensures that clear refmap is sent after the set */
-		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
+		__dlm_wait_on_lockres_flags(res, (DLM_LOCK_RES_SETREF_INPROG |
+						  DLM_LOCK_RES_MIGRATING));
 		spin_unlock(&res->spinlock);
 
 		/* clear our bit from the master's refmap, ignore errors */
-- 
1.5.6.3
