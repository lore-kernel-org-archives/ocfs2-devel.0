From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed,  2 Mar 2011 19:32:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: clean up mount option about atime
	in ocfs2.txt
In-Reply-To: <4D6E2994.1050302@oracle.com>
References: <4D6E2994.1050302@oracle.com>
Message-ID: <1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As ocfs2 supports relatime and strictatime, we need update the
relative document. Atime_quantum need work with strictatime, so only
show it in procfs when mount with strictatime.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    8 +++++++-
 fs/ocfs2/super.c                    |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 5393e66..a149606 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -46,9 +46,15 @@ errors=panic		Panic and halt the machine if an error occurs.
 intr		(*)	Allow signals to interrupt cluster operations.
 nointr			Do not allow signals to interrupt cluster
 			operations.
+noatime			Do not update access time.
+relatime(*)		Update atime if the previous atime is older than
+			mtime or ctime
+strictatime		Always update atime, but the minimum update interval
+			is specified by atime_quantum.
 atime_quantum=60(*)	OCFS2 will not update atime unless this number
 			of seconds has passed since the last update.
-			Set to zero to always update atime.
+			Set to zero to always update atime. This option need
+			work with strictatime.
 data=ordered	(*)	All data are forced directly out to the main file
 			system prior to its metadata being committed to the
 			journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 38f986d..f5463a6 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1564,7 +1564,7 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->preferred_slot != OCFS2_INVALID_SLOT)
 		seq_printf(s, ",preferred_slot=%d", osb->preferred_slot);
 
-	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
+	if (!(mnt->mnt_flags & MNT_NOATIME) && !(mnt->mnt_flags & MNT_RELATIME))
 		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
 
 	if (osb->osb_commit_interval)
-- 
1.7.2.1
