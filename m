From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:12 2008
Subject: [Ocfs2-devel] [PATCH 14/20] ocfs2: Fix comparison in
	ocfs2_size_fits_inline_data()
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 0d8a4e0cd688ad0de6430ce3425c7849cfec1c2d
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 20 Nov 2007 11:48:41 -0800

This was causing us to prematurely push out inline data by one byte.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4999180..25338ab 100644
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
