From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb  4 11:08:25 2008
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Move /sys/o2cb to /sys/fs/o2cb
In-Reply-To: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
References: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1202152062-28370-3-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>

/sys/fs is where we really want file system specific sysfs objects.

Ocfs2-tools has been updated to look in /sys/fs/o2cb. We can maintain
backwards compatibility with old ocfs2-tools by using a sysfs symlink. After
some time (2 years), the symlink can be safely removed. This patch also adds
documentation to make it easier for people to figure out what /sys/fs/o2cb
is used for.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/ABI/obsolete/o2cb            |   11 +++++++++++
 Documentation/ABI/stable/o2cb              |   10 ++++++++++
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 fs/ocfs2/cluster/sys.c                     |    9 +++++++++
 4 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/o2cb
 create mode 100644 Documentation/ABI/stable/o2cb

diff --git a/Documentation/ABI/obsolete/o2cb b/Documentation/ABI/obsolete/o2cb
new file mode 100644
index 0000000..9c49d8e
--- /dev/null
+++ b/Documentation/ABI/obsolete/o2cb
@@ -0,0 +1,11 @@
+What:		/sys/o2cb symlink
+Date:		Dec 2005
+KernelVersion:	2.6.16
+Contact:	ocfs2-devel@oss.oracle.com
+Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink will
+		be removed when new versions of ocfs2-tools which know to look
+		in /sys/fs/o2cb are sufficiently prevalent. Don't code new
+		software to look here, it should try /sys/fs/o2cb instead.
+		See Documentation/ABI/stable/o2cb for more information on usage.
+Users:		ocfs2-tools. It's sufficient to mail proposed changes to
+		ocfs2-devel@oss.oracle.com.
diff --git a/Documentation/ABI/stable/o2cb b/Documentation/ABI/stable/o2cb
new file mode 100644
index 0000000..5eb1545
--- /dev/null
+++ b/Documentation/ABI/stable/o2cb
@@ -0,0 +1,10 @@
+What:		/sys/fs/o2cb/ (was /sys/o2cb)
+Date:		Dec 2005
+KernelVersion:	2.6.16
+Contact:	ocfs2-devel@oss.oracle.com
+Description:	Ocfs2-tools looks at 'interface-revision' for versioning
+		information. Each logmask/ file controls a set of debug prints
+		and can be written into with the strings "allow", "deny", or
+		"off". Reading the file returns the current state.
+Users:		ocfs2-tools. It's sufficient to mail proposed changes to
+		ocfs2-devel@oss.oracle.com.
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2537066..2bedb81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -306,3 +306,13 @@ Why:	These drivers are superseded by i810fb, intelfb and savagefb.
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
+
+What:	/sys/o2cb symlink
+When:	January 2010
+Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
+	exists as a symlink for backwards compatibility for old versions of
+	ocfs2-tools. 2 years should be sufficient time to phase in new versions
+	which know to look in /sys/fs/o2cb.
+Who:	ocfs2-devel@oss.oracle.com
+
+---------------------------
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index a4b0773..bc702da 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -57,6 +57,7 @@ static struct kset *o2cb_kset;
 void o2cb_sys_shutdown(void)
 {
 	mlog_sys_shutdown();
+	sysfs_remove_link(NULL, "o2cb");
 	kset_unregister(o2cb_kset);
 }
 
@@ -68,6 +69,14 @@ int o2cb_sys_init(void)
 	if (!o2cb_kset)
 		return -ENOMEM;
 
+	/*
+	 * Create this symlink for backwards compatibility with old
+	 * versions of ocfs2-tools which look for things in /sys/o2cb.
+	 */
+	ret = sysfs_create_link(NULL, &o2cb_kset->kobj, "o2cb");
+	if (ret)
+		goto error;
+
 	ret = sysfs_create_group(&o2cb_kset->kobj, &o2cb_attr_group);
 	if (ret)
 		goto error;
-- 
1.5.3.6
