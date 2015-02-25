From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 25 Feb 2015 17:28:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: fix a typing error in
	ocfs2_direct_IO_write
Message-ID: <54ED95AE.2060601@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Only when direct IO succeeds we need consider zeroing out in case of
cluster not aligned.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 44db180..0c2848a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -771,7 +771,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 			if (ret < 0)
 				mlog_errno(ret);
 		}
-	} else if (written < 0 && append_write && !is_overwrite &&
+	} else if (written > 0 && append_write && !is_overwrite &&
 			!cluster_align) {
 		u32 p_cpos = 0;
 		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
-- 
1.8.4.3
