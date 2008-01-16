From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:11 2008
Subject: [Ocfs2-devel] [PATCH 16/20] ocfs2: fix exit-while-locked bug in
	ocfs2_queue_orphans()
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit a86370fbb65a0a2cb21d28bf25a748f6cc04385b
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 3 Dec 2007 14:06:23 -0800

We're holding the cluster lock when a failure might happen in
ocfs2_dir_foreach() so it needs to be released.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/journal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index aafd0a3..909a344 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1277,11 +1277,12 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 				   ocfs2_orphan_filldir);
 	if (status) {
 		mlog_errno(status);
-		goto out;
+		goto out_cluster;
 	}
 
 	*head = priv.head;
 
+out_cluster:
 	ocfs2_meta_unlock(orphan_dir_inode, 0);
 out:
 	mutex_unlock(&orphan_dir_inode->i_mutex);
-- 
1.5.3.4
