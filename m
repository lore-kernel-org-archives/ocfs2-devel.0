From: Jan Kara <jack@suse.cz>
Date: Wed, 15 Jul 2009 17:55:03 +0200
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Fix initialization of blockcheck
	stats
In-Reply-To: <1247673304-31080-1-git-send-email-jack@suse.cz>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
Message-ID: <1247673304-31080-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We just set blockcheck stats to zeros but we should also
properly initialize the spinlock there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7efb349..99c6dfe 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -777,6 +777,7 @@ static int ocfs2_sb_probe(struct super_block *sb,
 		}
 		di = (struct ocfs2_dinode *) (*bh)->b_data;
 		memset(stats, 0, sizeof(struct ocfs2_blockcheck_stats));
+		spin_lock_init(&stats->b_lock);
 		status = ocfs2_verify_volume(di, *bh, blksize, stats);
 		if (status >= 0)
 			goto bail;
-- 
1.6.0.2
