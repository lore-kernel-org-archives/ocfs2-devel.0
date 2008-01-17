From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:42 2008
Subject: [Ocfs2-devel] [PATCH 09/30] ocfs2: Documentation update
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-10-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Remove 'readpages' from the list in ocfs2.txt. Instead of having two
identical lists, I just removed the list in the OCFS2 section of fs/Kconfig
and added a pointer to Documentation/filesystems/ocfs2.txt.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    1 -
 fs/Kconfig                          |   10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index ed55238..e78abdc 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -35,7 +35,6 @@ Features which OCFS2 does not support yet:
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 	- POSIX ACLs
-	- readpages / writepages (not user visible)
 
 Mount options
 =============
diff --git a/fs/Kconfig b/fs/Kconfig
index 487236c..605ee07 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -440,14 +440,8 @@ config OCFS2_FS
 	  Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
 	  OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
-	  Note: Features which OCFS2 does not support yet:
-	          - extended attributes
-	          - quotas
-	          - cluster aware flock
-	          - Directory change notification (F_NOTIFY)
-	          - Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
-	          - POSIX ACLs
-	          - readpages / writepages (not user visible)
+	  For more information on OCFS2, see the file
+	  <file:Documentation/filesystems/ocfs2.txt>.
 
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
-- 
1.5.3.6
