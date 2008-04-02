From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:46 -0700
Subject: [Ocfs2-devel] [PATCH 36/62] ocfs2: Document /sys/fs/ocfs2
In-Reply-To: <1207167390414-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
Message-ID: <1207167392537-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

Add ABI documentation for these files:

	/sys/fs/ocfs2/max_locking_protocol
	/sys/fs/ocfs2/loaded_cluster_plugins
	/sys/fs/ocfs2/active_cluster_plugin
	/sys/fs/ocfs2/cluster_stack

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/ABI/testing/sysfs-ocfs2 |   89 +++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ocfs2

diff --git a/Documentation/ABI/testing/sysfs-ocfs2 b/Documentation/ABI/testing/sysfs-ocfs2
new file mode 100644
index 0000000..b7cc516
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-ocfs2
@@ -0,0 +1,89 @@
+What:		/sys/fs/ocfs2/
+Date:		April 2008
+Contact:	ocfs2-devel at oss.oracle.com
+Description:
+		The /sys/fs/ocfs2 directory contains knobs used by the
+		ocfs2-tools to interact with the filesystem.
+
+What:		/sys/fs/ocfs2/max_locking_protocol
+Date:		April 2008
+Contact:	ocfs2-devel at oss.oracle.com
+Description:
+		The /sys/fs/ocfs2/max_locking_protocol file displays version
+		of ocfs2 locking supported by the filesystem.  This version
+		covers how ocfs2 uses distributed locking between cluster
+		nodes.
+
+		The protocol version has a major and minor number.  Two
+		cluster nodes can interoperate if they have an identical
+		major number and an overlapping minor number - thus,
+		a node with version 1.10 can interoperate with a node
+		sporting version 1.8, as long as both use the 1.8 protocol.
+
+		Reading from this file returns a single line, the major
+		number and minor number joined by a period, eg "1.10".
+
+		This file is read-only.  The value is compiled into the
+		driver.
+
+What:		/sys/fs/ocfs2/loaded_cluster_plugins
+Date:		April 2008
+Contact:	ocfs2-devel at oss.oracle.com
+Description:
+		The /sys/fs/ocfs2/loaded_cluster_plugins file describes
+		the available plugins to support ocfs2 cluster operation.
+		A cluster plugin is required to use ocfs2 in a cluster.
+		There are currently two available plugins:
+
+		* 'o2cb' - The classic o2cb cluster stack that ocfs2 has
+			used since its inception.
+		* 'user' - A plugin supporting userspace cluster software
+			in conjunction with fs/dlm.
+
+		Reading from this file returns the names of all loaded
+		plugins, one per line.
+
+		This file is read-only.  Its contents may change as
+		plugins are loaded or removed.
+
+What:		/sys/fs/ocfs2/active_cluster_plugin
+Date:		April 2008
+Contact:	ocfs2-devel at oss.oracle.com
+Description:
+		The /sys/fs/ocfs2/active_cluster_plugin displays which
+		cluster plugin is currently in use by the filesystem.
+		The active plugin will appear in the loaded_cluster_plugins
+		file as well.  Only one plugin can be used at a time.
+
+		Reading from this file returns the name of the active plugin
+		on a single line.
+
+		This file is read-only.  Which plugin is active depends on
+		the cluster stack in use.  The contents may change
+		when all filesystems are unmounted and the cluster stack
+		is changed.
+
+What:		/sys/fs/ocfs2/cluster_stack
+Date:		April 2008
+Contact:	ocfs2-devel at oss.oracle.com
+Description:
+		The /sys/fs/ocfs2/cluster_stack file contains the name
+		of current ocfs2 cluster stack.  This value is set by
+		userspace tools when bringing the cluster stack online.
+
+		Cluster stack names are 4 characters in length.
+
+		When the 'o2cb' cluster stack is used, the 'o2cb' cluster
+		plugin is active.  All other cluster stacks use the 'user'
+		cluster plugin.
+
+		Reading from this file returns the name of the current
+		cluster stack on a single line.
+
+		Writing a new stack name to this file changes the current
+		cluster stack unless there are mounted ocfs2 filesystems.
+		If there are mounted filesystems, attempts to change the
+		stack return an error.
+
+Users:
+	ocfs2-tools <ocfs2-tools-devel@oss.oracle.com>
-- 
1.5.4.1
