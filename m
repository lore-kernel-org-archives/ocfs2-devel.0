From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:13 -0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: fix wake_up in unlock_ast
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: David Teigland <teigland@redhat.com>

Mainline commit 07f9eebcdfaeefc8f807fa1bcce1d7c3ae6661b1

In ocfs2_unlock_ast(), call wake_up() on lockres before releasing
the spin lock on it.  As soon as the spin lock is released, the
lockres can be freed.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7781ef1..fce142b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2756,9 +2756,8 @@ static void ocfs2_unlock_ast(void *opaque, enum dlm_status status)
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
 complete_unlock:
 	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
-	spin_unlock_irqrestore(&lockres->l_lock, flags);
-
 	wake_up(&lockres->l_event);
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	mlog_exit_void();
 }
-- 
1.5.6.3
