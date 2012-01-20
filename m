From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 20 Jan 2012 15:15:24 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: use find_last_bit
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <1327072528-8479-2-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

We already have find_last_bit. So just use it as described in the comment.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index cd36cb5..120fad9 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -956,23 +956,9 @@ out:
 	return changed;
 }
 
-/* This could be faster if we just implmented a find_last_bit, but I
- * don't think the circumstances warrant it. */
-static int o2hb_highest_node(unsigned long *nodes,
-			     int numbits)
+static int o2hb_highest_node(unsigned long *nodes, int numbits)
 {
-	int highest, node;
-
-	highest = numbits;
-	node = -1;
-	while ((node = find_next_bit(nodes, numbits, node + 1)) != -1) {
-		if (node >= numbits)
-			break;
-
-		highest = node;
-	}
-
-	return highest;
+	return find_last_bit(nodes, numbits);
 }
 
 static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
-- 
1.7.4.4
