From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 12:07:33 2007
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix comparison in
	ocfs2_size_fits_inline_data()
Message-ID: <20071120200722.GD28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This was causing us to prematurely push out inline data by one byte.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 556e34c..56f7790 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1514,7 +1514,7 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	if (new_size < le16_to_cpu(di->id2.i_data.id_count))
+	if (new_size <= le16_to_cpu(di->id2.i_data.id_count))
 		return 1;
 	return 0;
 }
-- 
1.5.3.4
