From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 17 Feb 2015 12:53:26 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: update web page + git tree in
	documentation
Message-ID: <20150217205326.GU21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, jlbec@evilplan.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

We (the Ocfs2 project) recently moved the location of our ocfs2-tools git
tree and project web page. The pertinent discussion can be seen here:

https://oss.oracle.com/pipermail/ocfs2-devel/2015-February/010579.html

The following patch updates the Ocfs2 documentation in MAINTAINERS,
ocfs2.txt, and dlmfs.txt. I added our new official web page, changed the
location of our tools git tree and removed the link to Joel's ancient kernel
git tree - Andrew has handled our patches for a while now.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Documentation/filesystems/dlmfs.txt | 4 ++--
 Documentation/filesystems/ocfs2.txt | 4 ++--
 MAINTAINERS                         | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/dlmfs.txt b/Documentation/filesystems/dlmfs.txt
index 1b528b2..fcf4d50 100644
--- a/Documentation/filesystems/dlmfs.txt
+++ b/Documentation/filesystems/dlmfs.txt
@@ -5,8 +5,8 @@ system.
 
 dlmfs is built with OCFS2 as it requires most of its infrastructure.
 
-Project web page:    http://oss.oracle.com/projects/ocfs2
-Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
+Project web page:    http://ocfs2.wiki.kernel.org
+Tools web page:      https://github.com/markfasheh/ocfs2-tools
 OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 28f8c08..4c49e54 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -8,8 +8,8 @@ also make it attractive for non-clustered use.
 You'll want to install the ocfs2-tools package in order to at least
 get "mount.ocfs2" and "ocfs2_hb_ctl".
 
-Project web page:    http://oss.oracle.com/projects/ocfs2
-Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
+Project web page:    http://ocfs2.wiki.kernel.org
+Tools git tree:      https://github.com/markfasheh/ocfs2-tools
 OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
diff --git a/MAINTAINERS b/MAINTAINERS
index 85024e2..dc63a8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7201,8 +7201,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mfasheh@suse.com>
 M:	Joel Becker <jlbec@evilplan.org>
 L:	ocfs2-devel at oss.oracle.com (moderated for non-subscribers)
-W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git
+W:	http://ocfs2.wiki.kernel.org
 S:	Supported
 F:	Documentation/filesystems/ocfs2.txt
 F:	Documentation/filesystems/dlmfs.txt
-- 
2.1.2
