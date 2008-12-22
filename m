From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:22 -0800
Subject: [Ocfs2-devel] [PATCH 41/56] ocfs2/quota: sparse fixes for quota
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-42-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

Fix 2 minor things in quota. They are both found by sparse check.
1. an endian bug in ocfs2_local_quota_add_chunk.
2. change olq_alloc_dquot to static.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_local.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 9b22643..5353c42 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -988,7 +988,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 		goto out_trans;
 	}
 	lock_buffer(bh);
-	dchunk->dqc_free = ol_quota_entries_per_block(sb);
+	dchunk->dqc_free = cpu_to_le32(ol_quota_entries_per_block(sb));
 	memset(dchunk->dqc_bitmap, 0,
 	       sb->s_blocksize - sizeof(struct ocfs2_local_disk_chunk) -
 	       OCFS2_QBLK_RESERVED_SPACE);
@@ -1110,7 +1110,7 @@ out:
 	return ERR_PTR(status);
 }
 
-void olq_alloc_dquot(struct buffer_head *bh, void *private)
+static void olq_alloc_dquot(struct buffer_head *bh, void *private)
 {
 	int *offset = private;
 	struct ocfs2_local_disk_chunk *dchunk;
-- 
1.5.6
