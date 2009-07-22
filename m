From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 13:17:16 +0200
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Mark buffer uptodate before
	calling ocfs2_journal_access_dq()
In-Reply-To: <1248261441-29384-1-git-send-email-jack@suse.cz>
References: <1248261441-29384-1-git-send-email-jack@suse.cz>
Message-ID: <1248261441-29384-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In a code path extending local quota files we marked new header
buffer uptodate only after calling ocfs2_journal_access_dq() which
triggers a bug. Fix it and also call ocfs2 variant of the function
marking buffer uptodate.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 5a460fa..b624f9b 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -20,6 +20,7 @@
 #include "sysfile.h"
 #include "dlmglue.h"
 #include "quota.h"
+#include "uptodate.h"
 
 /* Number of local quota structures per block */
 static inline unsigned int ol_quota_entries_per_block(struct super_block *sb)
@@ -979,6 +980,8 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		mlog_errno(status);
 		goto out;
 	}
+	ocfs2_set_new_buffer_uptodate(lqinode, bh);
+
 	dchunk = (struct ocfs2_local_disk_chunk *)bh->b_data;
 
 	handle = ocfs2_start_trans(OCFS2_SB(sb), 2);
@@ -999,7 +1002,6 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	memset(dchunk->dqc_bitmap, 0,
 	       sb->s_blocksize - sizeof(struct ocfs2_local_disk_chunk) -
 	       OCFS2_QBLK_RESERVED_SPACE);
-	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	status = ocfs2_journal_dirty(handle, bh);
 	if (status < 0) {
-- 
1.6.0.2
