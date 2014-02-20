From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Feb 2014 17:55:29 +0100
Subject: [Ocfs2-devel] [PATCH] quota: Fix race between dqput() and
	dquot_scan_active()
Message-ID: <1392915329-3464-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, Jan Kara <jack@suse.cz>

Currently last dqput() can race with dquot_scan_active() causing it to
call callback for an already deactivated dquot. The race is as follows:

CPU1					CPU2
  dqput()
    spin_lock(&dq_list_lock);
    if (atomic_read(&dquot->dq_count) > 1) {
     - not taken
    if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
      spin_unlock(&dq_list_lock);
      ->release_dquot(dquot);
        if (atomic_read(&dquot->dq_count) > 1)
         - not taken
					  dquot_scan_active()
					    spin_lock(&dq_list_lock);
					    if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
					     - not taken
					    atomic_inc(&dquot->dq_count);
					    spin_unlock(&dq_list_lock);
        - proceeds to release dquot
					    ret = fn(dquot, priv);
					     - called for inactive dquot

Fix the problem by making sure possible ->release_dquot() is finished by
the time we call the callback and new calls to it will notice reference
dquot_scan_active() has taken and bail out.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

  This is the last patch needed to make ocfs2 quotas rock solid in my testing.
I will carry it in my tree and push it to Linus soon.

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 831d49a4111f..cfc8dcc16043 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -581,9 +581,17 @@ int dquot_scan_active(struct super_block *sb,
 		dqstats_inc(DQST_LOOKUPS);
 		dqput(old_dquot);
 		old_dquot = dquot;
-		ret = fn(dquot, priv);
-		if (ret < 0)
-			goto out;
+		/*
+		 * ->release_dquot() can be racing with us. Our reference
+		 * protects us from new calls to it so just wait for any
+		 * outstanding call and recheck the DQ_ACTIVE_B after that.
+		 */
+		wait_on_dquot(dquot);
+		if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+			ret = fn(dquot, priv);
+			if (ret < 0)
+				goto out;
+		}
 		spin_lock(&dq_list_lock);
 		/* We are safe to continue now because our dquot could not
 		 * be moved out of the inuse list while we hold the reference */
-- 
1.8.1.4
