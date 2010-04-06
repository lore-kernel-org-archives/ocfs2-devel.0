From: Mark Fasheh <mfasheh@suse.com>
Date: Mon,  5 Apr 2010 18:17:15 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: change default reservation window
	sizes
In-Reply-To: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
References: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
Message-ID: <1270516636-12180-4-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The default reservation size of 4 (32-bit windows) is a bit too ambitious.
Scale it back to 16 bits (resv_level=2). I have been testing various sizes
on a 4-node cluster which runs a mixed workload that is heavily threaded.
With a 256MB local alloc, I get *roughly* the following levels of average file
fragmentation:

resv_level=0	70%
resv_level=1	21%
resv_level=2	23%
resv_level=3	24%
resv_level=4	60%
resv_level=5	did not test
resv_level=6	60%

resv_level=2 seemed like a good compromise between not letting windows be
too small, but not so big that heavier workloads will immediately suffer
without tuning.

This patch also change the behavior of directory reservations - they now
track file reservations.  The previous compromise of giving directory
windows only 8 bits wound up fragmenting more at some window sizes because
file allocations had smaller unused windows to poach from.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    2 +-
 fs/ocfs2/reservations.c             |    7 ++++---
 fs/ocfs2/reservations.h             |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 412df90..32339e5 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -80,6 +80,6 @@ user_xattr	(*)	Enables Extended User Attributes.
 nouser_xattr		Disables Extended User Attributes.
 acl			Enables POSIX Access Control Lists support.
 noacl		(*)	Disables POSIX Access Control Lists support.
-resv_level=4	(*)	Set how agressive allocation reservations will be.
+resv_level=2	(*)	Set how agressive allocation reservations will be.
 			Valid values are between 0 (reservations off) to 8
 			(maximum space for reservations).
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 7fc6cfe..87fa357 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -55,9 +55,10 @@ static unsigned int ocfs2_resv_window_bits(struct ocfs2_reservation_map *resmap,
 	if (!(resv->r_flags & OCFS2_RESV_FLAG_DIR)) {
 		/* 8, 16, 32, 64, 128, 256, 512, 1024 */
 		bits = 4 << osb->osb_resv_level;
-	} else
-		bits = OCFS2_RESV_DIR_WINDOW_BITS;
-
+	} else {
+		/* For now, treat directories the same as files. */
+		bits = 4 << osb->osb_resv_level;
+	}
 	return bits;
 }
 
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 34bb308..022aff6 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -22,7 +22,7 @@
 
 #include <linux/rbtree.h>
 
-#define OCFS2_DEFAULT_RESV_LEVEL	4
+#define OCFS2_DEFAULT_RESV_LEVEL	2
 #define OCFS2_MAX_RESV_LEVEL	9
 #define OCFS2_MIN_RESV_LEVEL	0
 
-- 
1.6.4.2
