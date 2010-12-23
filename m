From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:56 +0800
Subject: [Ocfs2-devel] [PATCH 13/34] ocfs2: remove INODE from unused files.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-13-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

As there are no such debug information in fs/ocfs2/ioctl.c,
fs/ocfs2/locks.c and fs/ocfs2/sysfile.c, ML_INODE are also
removed.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/acl.c   |    1 -
 fs/ocfs2/ioctl.c |    1 -
 fs/ocfs2/locks.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 3919150..ed28db8 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b4f51e9..d9bfa90 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -9,7 +9,6 @@
 #include <linux/mount.h>
 #include <linux/compat.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index b5cb3ed..e57c804 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -26,7 +26,6 @@
 #include <linux/fs.h>
 #include <linux/fcntl.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
-- 
1.7.0.4
