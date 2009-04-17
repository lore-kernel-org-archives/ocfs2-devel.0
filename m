From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:14 -0700
Subject: [Ocfs2-devel] [PATCH 01/26] ocfs2: Wakeup the downconvert thread
	after a successful cancel convert
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit a4b91965d39d5d53b470d6aa62cba155a6f3ffe1

When two nodes holding PR locks on a resource concurrently attempt to
upconvert the locks to EX, the master sends a BAST to one of the nodes. This
message tells that node to first cancel convert the upconvert request,
followed by downconvert to a NL. Only when this lock is downconverted to NL,
can the master upconvert the first node's lock to EX.

While the fs was doing the cancel convert, it was forgetting to wake up the
dc thread after a successful cancel, leading to a deadlock.

Reported-and-Tested-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7eceb0a..2580e4e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2745,6 +2745,10 @@ static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
 	case OCFS2_UNLOCK_CANCEL_CONVERT:
 		mlog(0, "Cancel convert success for %s\n", lockres->l_name);
 		lockres->l_action = OCFS2_AST_INVALID;
+		/* Downconvert thread may have requeued this lock, we
+		 * need to wake it. */
+		if (lockres->l_flags & OCFS2_LOCK_BLOCKED)
+			ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
 		break;
 	case OCFS2_UNLOCK_DROP_LOCK:
 		lockres->l_level = LKM_IVMODE;
-- 
1.5.6.3
