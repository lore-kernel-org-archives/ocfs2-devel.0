From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Jun  8 10:48:21 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070608174816.GG20632@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c            |   20 ++++++++++----------
 fs/ocfs2/cluster/masklog.c |    3 +--
 2 files changed, 11 insertions(+), 12 deletions(-)

Mark Fasheh:
      ocfs2: Fix invalid assertion during write on 64k pages

Tiger Yang:
      ocfs2: Fix masklog breakage

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0023b31..a480b09 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -798,6 +798,11 @@ int ocfs2_map_and_write_splice_data(stru
 	}
 	to = from + bytes;
 
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from < cluster_start);
+	BUG_ON(to > cluster_end);
+
 	if (wc->w_this_page_new)
 		ret = ocfs2_map_page_blocks(wc->w_this_page, p_blkno, inode,
 					    cluster_start, cluster_end, 1);
@@ -809,11 +814,6 @@ int ocfs2_map_and_write_splice_data(stru
 		goto out;
 	}
 
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
-	BUG_ON(from > osb->s_clustersize);
-	BUG_ON(to > osb->s_clustersize);
-
 	src = buf->ops->map(sp->s_pipe, buf, 1);
 	dst = kmap_atomic(wc->w_this_page, KM_USER1);
 	memcpy(dst + from, src + src_from, bytes);
@@ -890,6 +890,11 @@ int ocfs2_map_and_write_user_data(struct
 
 	to = from + bytes;
 
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from < cluster_start);
+	BUG_ON(to > cluster_end);
+
 	if (wc->w_this_page_new)
 		ret = ocfs2_map_page_blocks(wc->w_this_page, p_blkno, inode,
 					    cluster_start, cluster_end, 1);
@@ -901,11 +906,6 @@ int ocfs2_map_and_write_user_data(struct
 		goto out;
 	}
 
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
-	BUG_ON(from > osb->s_clustersize);
-	BUG_ON(to > osb->s_clustersize);
-
 	dst = kmap(wc->w_this_page);
 	memcpy(dst + from, bp->b_src_buf + src_from, bytes);
 	kunmap(wc->w_this_page);
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index a93620c..2b205f5 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -144,8 +144,7 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj  = {.name = "logmask"},
-	.ktype = &mlog_ktype
+	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
