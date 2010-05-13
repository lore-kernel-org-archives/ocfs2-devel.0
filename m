From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:58:01 +0200
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: Fix estimate of credits needed for
	quota allocation
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We were missing reservation of a journal credit for modification of quota
file inode when creating new dquot structure in the global quota file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 2cf080c..f555652 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -470,9 +470,10 @@ static int ocfs2_global_qinit_alloc(struct super_block *sb, int type)
 
 static int ocfs2_calc_global_qinit_credits(struct super_block *sb, int type)
 {
-	/* We modify all the allocated blocks, tree root, and info block */
+	/* We modify all the allocated blocks, tree root, info block and
+	 * the inode */
 	return (ocfs2_global_qinit_alloc(sb, type) + 2) *
-			OCFS2_QUOTA_BLOCK_UPDATE_CREDITS;
+			OCFS2_QUOTA_BLOCK_UPDATE_CREDITS + 1;
 }
 
 /* Sync local information about quota modifications with global quota file.
-- 
1.6.4.2
