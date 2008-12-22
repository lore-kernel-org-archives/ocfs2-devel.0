From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:15 -0800
Subject: [Ocfs2-devel] [PATCH 34/56] ocfs2: Fix build warnings (64-bit types
	vs long long)
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-35-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

fs/ocfs2/quota_local.c: In function 'olq_set_dquot':
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 7 has type '__le64'
fs/ocfs2/quota_local.c:844: warning: format '%lld' expects type 'long long int', but argument 8 has type '__le64'
fs/ocfs2/quota_global.c: In function '__ocfs2_sync_dquot':
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 8 has type 's64'
fs/ocfs2/quota_global.c:457: warning: format '%lld' expects type 'long long int', but argument 10 has type 's64'

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |    6 +++---
 fs/ocfs2/quota_local.c  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 27a8123..b0eae79 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -455,9 +455,9 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
 	olditime = dquot->dq_dqb.dqb_itime;
 	oldbtime = dquot->dq_dqb.dqb_btime;
 	ocfs2_global_disk2memdqb(dquot, &dqblk);
-	mlog(0, "Syncing global dquot %d space %lld+%lld, inodes %lld+%lld\n",
-	     dquot->dq_id, dquot->dq_dqb.dqb_curspace, spacechange,
-	     dquot->dq_dqb.dqb_curinodes, inodechange);
+	mlog(0, "Syncing global dquot %u space %lld+%lld, inodes %lld+%lld\n",
+	     dquot->dq_id, dquot->dq_dqb.dqb_curspace, (long long)spacechange,
+	     dquot->dq_dqb.dqb_curinodes, (long long)inodechange);
 	if (!test_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags))
 		dquot->dq_dqb.dqb_curspace += spacechange;
 	if (!test_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags))
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c008dd9..9b22643 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -848,7 +848,8 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
 					  od->dq_originodes);
 	spin_unlock(&dq_data_lock);
 	mlog(0, "Writing local dquot %u space %lld inodes %lld\n",
-	     od->dq_dquot.dq_id, dqblk->dqb_spacemod, dqblk->dqb_inodemod);
+	     od->dq_dquot.dq_id, (long long)le64_to_cpu(dqblk->dqb_spacemod),
+	     (long long)le64_to_cpu(dqblk->dqb_inodemod));
 }
 
 /* Write dquot to local quota file */
-- 
1.5.6
