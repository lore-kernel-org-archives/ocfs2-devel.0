From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:18 2008
Subject: [Ocfs2-devel] [PATCH 12/20] ocfs2: Remove expensive bitmap scanning
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 5a58c3ef22d6e5b84ff651a7d27ae2cbea9f9870
Author: Jan Kara <jack@suse.cz>
Date: Tue, 13 Nov 2007 19:59:33 +0100

Enable expensive bitmap scanning only if DEBUG option is enabled.
The bitmap scanning quite loads the CPU and on my machine the write
throughput of dd if=/dev/zero of=/ocfs2/file bs=1M count=500 conv=sync
improves from 37 MB/s to 45.4 MB/s in local mode...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/localalloc.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index d272847..e29328a 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -484,17 +484,6 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 
-	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
-	    ocfs2_local_alloc_count_bits(alloc)) {
-		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-			    "%u free bits, but a count shows %u",
-			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
-			    le32_to_cpu(alloc->id1.bitmap1.i_used),
-			    ocfs2_local_alloc_count_bits(alloc));
-		status = -EIO;
-		goto bail;
-	}
-
 	free_bits = le32_to_cpu(alloc->id1.bitmap1.i_total) -
 		le32_to_cpu(alloc->id1.bitmap1.i_used);
 	if (bits_wanted > free_bits) {
@@ -712,9 +701,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	void *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	mlog_entry("total = %u, COUNT = %u, used = %u\n",
+	mlog_entry("total = %u, used = %u\n",
 		   le32_to_cpu(alloc->id1.bitmap1.i_total),
-		   ocfs2_local_alloc_count_bits(alloc),
 		   le32_to_cpu(alloc->id1.bitmap1.i_used));
 
 	if (!alloc->id1.bitmap1.i_total) {
-- 
1.5.3.4
