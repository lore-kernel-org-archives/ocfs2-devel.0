From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed,  2 Mar 2011 19:30:37 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-tools: support strictatime in ocfs2
In-Reply-To: <4D6E2994.1050302@oracle.com>
References: <4D6E2994.1050302@oracle.com>
Message-ID: <1299065437-6594-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Strictatime was introduced into vfs, so this patch adding support
to it in ocfs2. Now we have three types behavior about update atime,
noatime, relatime and strictatime. With strictatime, the minimum
update interval is specified by atime_quantum, which defaults to 60 secs.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 mount.ocfs2/mount.ocfs2.8.in  |   11 ++++++-----
 mount.ocfs2/mount_constants.h |    3 +++
 mount.ocfs2/opts.c            |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mount.ocfs2/mount.ocfs2.8.in b/mount.ocfs2/mount.ocfs2.8.in
index b367bf1..3bd1d09 100644
--- a/mount.ocfs2/mount.ocfs2.8.in
+++ b/mount.ocfs2/mount.ocfs2.8.in
@@ -20,17 +20,18 @@ specify this mount option to delay the system from mounting the volume until
 after the network has been enabled.
 
 .TP
-\fBatime\_quantum=nrsec\fR
-The file system will not update atime unless this number of seconds has passed
-since the last update. Set to zero to always update atime. It defaults to 60 secs.
+\fBnoatime\fR
+The file system will not update access time.
 
 .TP
 \fBrelatime\fR
 The file system only update atime if the previous atime is older than mtime or ctime.
 
 .TP
-\fBnoatime\fR
-The file system will not update access time.
+\fBstrictatime,atime\_quantum=nrsec\fR
+The file system will always perform atime updates, but the minimum update
+interval is specified by atime_quantum. Atime_quantum defaults to 60 secs,
+set it to zero to always update atime. These two options need work together.
 
 .TP
 \fBacl / noacl\fR
diff --git a/mount.ocfs2/mount_constants.h b/mount.ocfs2/mount_constants.h
index ed475db..feffe8f 100644
--- a/mount.ocfs2/mount_constants.h
+++ b/mount.ocfs2/mount_constants.h
@@ -60,6 +60,9 @@ if we have a stack or plain mount - mount atop of it, forming a stack. */
 #ifndef MS_RELATIME
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #endif
+#ifndef MS_STRICTATIME
+#define MS_STRICTATIME	(1<<24)	/* Strict atime semantics */
+#endif
 /*
  * Magic mount flag number. Had to be or-ed to the flag values.
  */
diff --git a/mount.ocfs2/opts.c b/mount.ocfs2/opts.c
index 5ecd36b..96037da 100644
--- a/mount.ocfs2/opts.c
+++ b/mount.ocfs2/opts.c
@@ -78,12 +78,12 @@ static const struct opt_map opt_map[] = {
   { "mand",	0, 0, MS_MANDLOCK },	/* Allow mandatory locks on this FS */
   { "nomand",	0, 1, MS_MANDLOCK },	/* Forbid mandatory locks on this FS */
   { "loop",	1, 0, MS_LOOP	},	/* use a loop device */
-  { "atime",	0, 1, MS_NOATIME },	/* Update access time */
   { "noatime",	0, 0, MS_NOATIME },	/* Do not update access time */
   { "relatime",	0, 0, MS_RELATIME },	/* only update atime if previous */
 					/* atime is older than mtime/ctime */
   { "diratime",	0, 1, MS_NODIRATIME },	/* Update dir access times */
   { "nodiratime", 0, 0, MS_NODIRATIME },/* Do not update dir access times */
+  { "strictatime", 0, 0, MS_STRICTATIME },/* Strict atime semantics */
   { "kudzu",	0, 0, MS_COMMENT },	/* Silently remove this option (backwards compat use only) */
   { "managed",	0, 0, MS_COMMENT },	/* Silently remove this option */
   { NULL,	0, 0, 0	}
-- 
1.7.2.1
