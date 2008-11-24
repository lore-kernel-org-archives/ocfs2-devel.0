From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 25 Nov 2008 07:21:36 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/quota: minor fix for quota.
In-Reply-To: <492BA5B1.20005@oracle.com>
References: <492BA5B1.20005@oracle.com>
Message-ID: <1227568896-6724-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Fix 2 minor things in quota. They are both found by sparse check.
1. an endian bug in ocfs2_local_quota_add_chunk.
2. change olq_alloc_dquot to static.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/quota_local.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 54e8788..3d6c31f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -981,7 +981,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out_trans;
 	}
 	lock_buffer(bh);
-	dchunk->dqc_free = ol_quota_entries_per_block(sb);
+	dchunk->dqc_free = cpu_to_le32(ol_quota_entries_per_block(sb));
 	memset(dchunk->dqc_bitmap, 0,
 	       sb->s_blocksize - sizeof(struct ocfs2_local_disk_chunk) -
 	       OCFS2_QBLK_RESERVED_SPACE);
@@ -1103,7 +1103,7 @@ out:
 	return ERR_PTR(status);
 }
 
-void olq_alloc_dquot(struct buffer_head *bh, void *private)
+static void olq_alloc_dquot(struct buffer_head *bh, void *private)
 {
 	int *offset = private;
 	struct ocfs2_local_disk_chunk *dchunk;
-- 
1.5.4.GIT
