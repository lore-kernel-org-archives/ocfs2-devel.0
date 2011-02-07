From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Mon, 07 Feb 2011 14:50:58 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: use find_last_bit
Message-ID: <1297090306-15501-1-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have find_last_bit() these days.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b108e86..e54f665 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -924,23 +924,9 @@ out:
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
1.7.4
