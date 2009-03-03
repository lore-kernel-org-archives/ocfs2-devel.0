From: Tiger Yang <tiger.yang@oracle.com>
Date: Tue,  3 Mar 2009 10:48:36 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: update ocfs2 document about mount
	option
Message-ID: <1236048516-5963-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add mount option relatime and noatime
in ocfs2 document.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index c2a0871..f1b8276 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -48,6 +48,9 @@ nointr			Do not allow signals to interrupt cluster
 atime_quantum=60(*)	OCFS2 will not update atime unless this number
 			of seconds has passed since the last update.
 			Set to zero to always update atime.
+relatime		Only update atime if previous atime is older than
+			mtime or ctime.
+noatime			Do not update atime.
 data=ordered	(*)	All data are forced directly out to the main file
 			system prior to its metadata being committed to the
 			journal.
-- 
1.5.4.1
