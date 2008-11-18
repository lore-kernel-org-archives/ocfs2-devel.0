From: Andrew Beekhof <abeekhof@suse.de>
Date: Tue, 18 Nov 2008 11:18:38 +0100
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint warnings in
	init scripts
Message-ID: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Fix a number of LSB compliance issues reported by rpmlint regarding  
ocfs2 init scripts

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>

--- upstream/vendor/common/o2cb.init.sh	2008-09-11 16:51:11.000000000  
+0200
+++ dev/vendor/common/o2cb.init.sh	2008-10-23 14:36:49.000000000 +0200
@@ -8,7 +8,8 @@
  # Provides: o2cb
  # Required-Start: $network
  # Should-Start:
-# Required-Stop:
+# Should-Stop:
+# Required-Stop: $null
  # Default-Start: 2 3 5
  # Default-Stop:
  # Short-Description: Load O2CB cluster services at system boot.
--- upstream/vendor/common/ocfs2.init	2008-09-11 16:51:11.000000000  
+0200
+++ dev/vendor/common/ocfs2.init	2008-10-23 13:13:55.000000000 +0200
@@ -8,9 +8,9 @@
  ### BEGIN INIT INFO
  # Provides: ocfs2
  # Required-Start: $network o2cb
-# Required-Stop:
-# X-UnitedLinux-Should-Start:
-# X-UnitedLinux-Should-Stop:
+# Required-Stop: $null
+# Should-Start:
+# Should-Stop:
  # Default-Start:  2 3 5
  # Default-Stop:
  # Short-Description: Mount OCFS2 volumes at boot.
