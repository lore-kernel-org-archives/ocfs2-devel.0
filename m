From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 13 May 2011 12:02:54 -0700
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: Skip mount recovery for hard-ro
	mounts
In-Reply-To: <1305313378-31191-1-git-send-email-sunil.mushran@oracle.com>
References: <1305313378-31191-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1305313378-31191-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch skips mount recovery for hard-ro mounts which otherwise leads to an oops.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index dcc2d93..c9699a7 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1260,6 +1260,9 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
 {
 	struct ocfs2_journal *journal = osb->journal;
 
+	if (ocfs2_is_hard_readonly(osb))
+		return;
+
 	/* No need to queue up our truncate_log as regular cleanup will catch
 	 * that */
 	ocfs2_queue_recovery_completion(journal, osb->slot_num,
-- 
1.7.4.1
