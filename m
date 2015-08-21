From: Gang He <ghe@suse.com>
Date: Fri, 21 Aug 2015 15:43:18 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: add errno and macro definitions
In-Reply-To: <1440143000-24956-1-git-send-email-ghe@suse.com>
References: <1440143000-24956-1-git-send-email-ghe@suse.com>
Message-ID: <1440143000-24956-3-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Add new errno, macro definitions and header file inclusion,
which will be used for file extent block online check.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/filecheck.c | 4 ++++
 fs/ocfs2/filecheck.h | 1 +
 fs/ocfs2/journal.h   | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 4b5a673..e8bc0cf 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -31,7 +31,10 @@
 #include "ocfs2.h"
 #include "ocfs2_fs.h"
 #include "stackglue.h"
+#include "dlmglue.h"
 #include "inode.h"
+#include "alloc.h"
+#include "journal.h"
 
 #include "filecheck.h"
 
@@ -45,6 +48,7 @@ static const char * const ocfs2_filecheck_errs[] = {
 	"INPROGRESS",
 	"READONLY",
 	"INVALIDINO",
+	"INVALIDEXT",
 	"BLOCKECC",
 	"BLOCKNO",
 	"VALIDFLAG",
diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
index 5ec331b..e9c3fe6 100644
--- a/fs/ocfs2/filecheck.h
+++ b/fs/ocfs2/filecheck.h
@@ -32,6 +32,7 @@ enum {
 	OCFS2_FILECHECK_ERR_INPROGRESS,		/* In progress */
 	OCFS2_FILECHECK_ERR_READONLY,		/* Read only */
 	OCFS2_FILECHECK_ERR_INVALIDINO,		/* Invalid ino */
+	OCFS2_FILECHECK_ERR_INVALIDEXT,		/* Invalid extent block */
 	OCFS2_FILECHECK_ERR_BLOCKECC,		/* Block ecc */
 	OCFS2_FILECHECK_ERR_BLOCKNO,		/* Block number */
 	OCFS2_FILECHECK_ERR_VALIDFLAG,		/* Inode valid flag */
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index f4cd3c3..8ab70cd 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -350,6 +350,9 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh);
 /* simple file updates like chmod, etc. */
 #define OCFS2_INODE_UPDATE_CREDITS 1
 
+/* extent block update */
+#define OCFS2_EXTENT_BLOCK_UPDATE_CREDITS 1
+
 /* extended attribute block update */
 #define OCFS2_XATTR_BLOCK_UPDATE_CREDITS 1
 
-- 
2.1.2
