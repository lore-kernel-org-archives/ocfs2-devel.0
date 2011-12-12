From: roel <roel.kluin@gmail.com>
Date: Mon, 12 Dec 2011 23:40:51 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Misplaced parens in unlikley
Message-ID: <4EE682F3.9070905@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, moderated for non-subscribers <ocfs2-devel@oss.oracle.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

Fix misplaced parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 81a4cd2..274529c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -456,7 +456,7 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
 	stats->ls_gets++;
 	stats->ls_total += ktime_to_ns(kt);
 	/* overflow */
-	if (unlikely(stats->ls_gets) == 0) {
+	if (unlikely(stats->ls_gets == 0)) {
 		stats->ls_gets++;
 		stats->ls_total = ktime_to_ns(kt);
 	}
