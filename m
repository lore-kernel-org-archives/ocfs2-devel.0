From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:42 -0700
Subject: [Ocfs2-devel] [PATCH 09/17] ocfs2: Don't snprintf() without a
	format.
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-10-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

Some system files are per-slot.  Their names include the slot number.
ocfs2_sprintf_system_inode_name() uses the system inode definitions to
fill in the slot number with snprintf().

For global system files, there is no node number, and the name was
printed as a format with no arguments.  -Wformat-nonliteral and
-Wformat-security don't like this.  Instead, use a static "%s" format
and the name as the argument.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 52c4266..3f19451 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -901,7 +901,7 @@ static inline int ocfs2_sprintf_system_inode_name(char *buf, int len,
          * list has a copy per slot.
          */
 	if (type <= OCFS2_LAST_GLOBAL_SYSTEM_INODE)
-		chars = snprintf(buf, len,
+		chars = snprintf(buf, len, "%s",
 				 ocfs2_system_inodes[type].si_name);
 	else
 		chars = snprintf(buf, len,
-- 
1.5.4.1
