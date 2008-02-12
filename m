From: marcin.slusarz at gmail.com <marcin.slusarz@gmail.com>
Date: Tue, 12 Feb 2008 23:11:24 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: le*_add_cpu conversion
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
Message-ID: <1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>, ocfs2-devel@oss.oracle.com

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/dir.c        |    5 ++---
 fs/ocfs2/localalloc.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e280833..8a18758 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -390,9 +390,8 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				goto bail;
 			}
 			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
+				le16_add_cpu(&pde->rec_len,
+						le16_to_cpu(de->rec_len));
 			else
 				de->inode = 0;
 			dir->i_version++;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index add1ffd..d0e217e 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -588,8 +588,7 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	while(bits_wanted--)
 		ocfs2_set_bit(start++, bitmap);
 
-	alloc->id1.bitmap1.i_used = cpu_to_le32(*num_bits +
-				le32_to_cpu(alloc->id1.bitmap1.i_used));
+	le32_add_cpu(&alloc->id1.bitmap1.i_used, *num_bits);
 
 	status = ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 	if (status < 0) {
-- 
1.5.3.7
