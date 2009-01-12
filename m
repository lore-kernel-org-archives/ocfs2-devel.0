From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Jan 2009 23:20:32 +0100
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Fix possible deadlock in
	ocfs2_write_dquot()
In-Reply-To: <1231798833-6850-4-git-send-email-jack@suse.cz>
References: <y> <1231798833-6850-1-git-send-email-jack@suse.cz>
	<1231798833-6850-2-git-send-email-jack@suse.cz>
	<1231798833-6850-3-git-send-email-jack@suse.cz>
	<1231798833-6850-4-git-send-email-jack@suse.cz>
Message-ID: <1231798833-6850-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It could happen that some limit has been set via quotactl() and in parallel
->mark_dirty() is called from another thread doing e.g. dquot_alloc_space(). In
such case ocfs2_write_dquot() must not try to sync the dquot because that needs
global quota lock but that ranks above transaction start.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index f4efa89..1ed0f7c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -754,7 +754,9 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	if (dquot->dq_flags & mask)
 		sync = 1;
 	spin_unlock(&dq_data_lock);
-	if (!sync) {
+	/* This is a slight hack but we can't afford getting global quota
+	 * lock if we already have a transaction started. */
+	if (!sync || journal_current_handle()) {
 		status = ocfs2_write_dquot(dquot);
 		goto out;
 	}
-- 
1.6.0.2
