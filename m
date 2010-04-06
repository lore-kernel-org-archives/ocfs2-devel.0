From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  6 Apr 2010 16:46:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Code cleanup for allocation
	reservation.
Message-ID: <1270543606-5338-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Two tiny cleanup for allocation reservation.
1. Remove some extra codes in ocfs2_local_alloc_find_clear_bits.
2. Remove an unuseful variables in ocfs2_find_resv_lhs.

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c   |    7 ++-----
 fs/ocfs2/reservations.c |    2 --
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 2882f79..0b32113 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -879,13 +879,10 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 	mlog(0, "Exiting loop, bitoff = %d, numfound = %d\n", bitoff,
 	     numfound);
 
-	if (numfound == *numbits) {
+	if (numfound == *numbits)
 		bitoff = startoff - numfound;
-		*numbits = numfound;
-	} else {
-		numfound = 0;
+	else
 		bitoff = -1;
-	}
 
 bail:
 	if (local_resv)
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 6497bcc..32bad4a 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -371,7 +371,6 @@ ocfs2_find_resv_lhs(struct ocfs2_reservation_map *resmap, unsigned int goal)
 	struct ocfs2_alloc_reservation *resv = NULL;
 	struct ocfs2_alloc_reservation *prev_resv = NULL;
 	struct rb_node *node = resmap->m_reservations.rb_node;
-	struct rb_node *prev = NULL;
 
 	assert_spin_locked(&resv_lock);
 
@@ -392,7 +391,6 @@ ocfs2_find_resv_lhs(struct ocfs2_reservation_map *resmap, unsigned int goal)
 		}
 
 		prev_resv = resv;
-		prev = node;
 		node = rb_next(node);
 	}
 
-- 
1.5.5
