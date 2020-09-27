From: Gang He <ghe@suse.com>
Date: Sun, 27 Sep 2020 09:58:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix potential soft lockup during fstrim
Message-ID: <20200927015815.14904-1-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

When we discard unused blocks on a mounted ocfs2 filesystem, fstrim
handles each block goup with locking/unlocking global bitmap meta-file
repeatedly. we should let fstrim thread take a break(if need) between
unlock and lock, this will avoid the potential soft lockup problem,
and also gives the upper applications more IO opportunities, these
applications are not blocked for too long at writing files.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4c1b90442d6f..2cf9321919b5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7654,8 +7654,10 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
 	 * main_bm related locks for avoiding the current IO starve, then go to
 	 * trim the next group
 	 */
-	if (ret >= 0 && group <= last_group)
+	if (ret >= 0 && group <= last_group) {
+		cond_resched();
 		goto next_group;
+	}
 out:
 	range->len = trimmed * sb->s_blocksize;
 	return ret;
-- 
2.21.0
