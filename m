From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Fri, 16 Oct 2020 17:11:57 +0800
Subject: [Ocfs2-devel] [patch -next] ocfs2: Add the
	trace_ocfs2_read_blocks_end
Message-ID: <20201016091157.29039-1-zhangqilong3@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Missing the trace_ocfs2_read_blocks_end when reading blocks fails.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 fs/ocfs2/buffer_head_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index f0b104e483d8..0e6ee6e9b201 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -395,11 +395,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 
+bail:
 	trace_ocfs2_read_blocks_end((unsigned long long)block, nr,
 				    flags, ignore_cache);
 
-bail:
-
 	return status;
 }
 
-- 
2.17.1
