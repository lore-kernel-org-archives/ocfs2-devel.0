From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Fri, 10 Apr 2015 15:44:26 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] automated tool detected uninitialized
	variable use in ocfs2_local_alloc_find_clear_bits
Message-ID: <1428705866-26954-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 19060842

In ocfs2_local_alloc_find_clear_bits(), local int numbits is used
without being initialized in an error path.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
---
 fs/ocfs2/localalloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 0440134..978a6e0 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -847,6 +847,7 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 
 	if (!alloc->id1.bitmap1.i_total) {
 		bitoff = -1;
+		numfound = -1;
 		goto bail;
 	}
 
-- 
1.7.1
