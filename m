From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 13:17:15 +0200
Subject: [Ocfs2-devel] [PATCH 1/7] ocfs2: Make global quota files blocksize
	aligned
In-Reply-To: <1248261441-29384-1-git-send-email-jack@suse.cz>
References: <1248261441-29384-1-git-send-email-jack@suse.cz>
Message-ID: <1248261441-29384-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change i_size of global quota files so that it always remains aligned to block
size. This is mainly because the end of quota block may contain checksum (if
checksumming is enabled) and it's a bit awkward for it to be "outside" of quota
file (and it makes life harder for ocfs2-tools).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index edfa60c..a66cb82 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -211,14 +211,17 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 
 	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
 	if (gqinode->i_size < off + len) {
+		loff_t rounded_end =
+				ocfs2_align_bytes_to_blocks(sb, off + len);
+
 		down_write(&OCFS2_I(gqinode)->ip_alloc_sem);
-		err = ocfs2_extend_no_holes(gqinode, off + len, off);
+		err = ocfs2_extend_no_holes(gqinode, rounded_end, off);
 		up_write(&OCFS2_I(gqinode)->ip_alloc_sem);
 		if (err < 0)
 			goto out;
 		err = ocfs2_simple_size_update(gqinode,
 					       oinfo->dqi_gqi_bh,
-					       off + len);
+					       rounded_end);
 		if (err < 0)
 			goto out;
 		new = 1;
-- 
1.6.0.2
