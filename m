From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:40 +0100
Subject: [Ocfs2-devel] [PATCH 5/7] quota: Remove dqonoff_mutex from
	dquot_scan_active()
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

All callers of dquot_scan_active() now hold s_umount so we can rely on
that lock to protect us against quota state changes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 2a9dc3fb491c..d91aecc939c9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -572,7 +572,8 @@ int dquot_scan_active(struct super_block *sb,
 	struct dquot *dquot, *old_dquot = NULL;
 	int ret = 0;
 
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
+	WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));
+
 	spin_lock(&dq_list_lock);
 	list_for_each_entry(dquot, &inuse_list, dq_inuse) {
 		if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
@@ -603,7 +604,6 @@ int dquot_scan_active(struct super_block *sb,
 	spin_unlock(&dq_list_lock);
 out:
 	dqput(old_dquot);
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(dquot_scan_active);
-- 
2.6.6
