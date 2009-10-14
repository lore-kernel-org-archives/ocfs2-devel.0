From: Joel Becker <joel.becker@ORACLE.COM>
Date: Wed, 14 Oct 2009 02:57:40 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] vfs: Add MAY_CREATE to the permission()
	flags.
In-Reply-To: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
References: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1255514261-25823-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org, torvalds@linux-foundation.org

A simple rule of system calls is that you cannot return -ERESTARTSYS
after you've made non-idempotent changes.  ocfs2 has run into this with
open(O_CREAT|O_EXCL).  Once you've created the file, you can't restart
the open(), because O_CREAT|O_EXCL will trigger -EEXIST.

The problem is that ocfs2 is catching the signal ->permission(), called
by may_open().  This happens after ->create() has successfully created
the file.  ocfs2_permission() has to get a cluster lock, and this is
what can be interrupted by a signal.  Now, obviously we want to block
signals in the O_CREAT|O_EXCL case, but ocfs2_permission() has no way of
knowing it just got called from open_namei_create().

So we add the MAY_CREATE flag to permission().  open_namei_create() will
pass it to may_open(), and then ocfs2 can block signals in
ocfs2_permission() as appropriate.  The same is true of any other
filesystem that has to do work in may_open().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/namei.c         |    2 +-
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d11f404..d54cb98 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1623,7 +1623,7 @@ out_unlock:
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
-	return may_open(&nd->path, 0, flag & ~O_TRUNC);
+	return may_open(&nd->path, MAY_CREATE, flag & ~O_TRUNC);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..b1a454c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,7 @@ struct inodes_stat_t {
 #define MAY_APPEND 8
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
+#define MAY_CREATE 64
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
1.6.3.3
