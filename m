From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:20 -0800
Subject: [Ocfs2-devel] [PATCH 15/15] typos: fix similar typos to successfull
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Coly Li <coyli@suse.de>

Mainline commit 73ac36ea14fd18ea3dc057e41b16ff31a3c0bd5a

When I review ocfs2 code, find there are 2 typos to "successfull".  After
doing grep "successfull " in kernel tree, 22 typos found totally -- great
minds always think alike :)

This patch fixes all the similar typos. Thanks for Randy's ack and comments.

Signed-off-by: Coly Li <coyli@suse.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Roland Dreier <rolandd@cisco.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ocfs2/dlmglue.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index fce142b..7eceb0a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -978,7 +978,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 		ocfs2_recover_from_dlm_error(lockres, 1);
 	}
 
-	mlog(0, "lock %s, successfull return from dlmlock\n", lockres->l_name);
+	mlog(0, "lock %s, successful return from dlmlock\n", lockres->l_name);
 
 bail:
 	mlog_exit(ret);
@@ -1189,7 +1189,7 @@ again:
 			goto out;
 		}
 
-		mlog(0, "lock %s, successfull return from dlmlock\n",
+		mlog(0, "lock %s, successful return from dlmlock\n",
 		     lockres->l_name);
 
 		/* At this point we've gone inside the dlm and need to
@@ -2837,7 +2837,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 		dlm_print_one_lock(lockres->l_lksb.lockid);
 		BUG();
 	}
-	mlog(0, "lock %s, successfull return from dlmunlock\n",
+	mlog(0, "lock %s, successful return from dlmunlock\n",
 	     lockres->l_name);
 
 	ocfs2_wait_on_busy_lock(lockres);
-- 
1.5.6.3
