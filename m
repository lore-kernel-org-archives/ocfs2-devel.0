From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:01 -0700
Subject: [Ocfs2-devel] [PATCH 51/62] ocfs2: Move /sys/o2cb to /sys/fs/o2cb
In-Reply-To: <12071674242631-git-send-email-mfasheh@suse.com>
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
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
Message-ID: <1207167425415-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

/sys/fs is where we really want file system specific sysfs objects.

Ocfs2-tools has been updated to look in /sys/fs/o2cb. We can maintain
backwards compatibility with old ocfs2-tools by using a sysfs symlink. After
some time (2 years), the symlink can be safely removed. This patch also adds
documentation to make it easier for people to figure out what /sys/fs/o2cb
is used for.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
+Contact:	ocfs2-devel at oss.oracle.com
+Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink will
+		be removed when new versions of ocfs2-tools which know to look
+		in /sys/fs/o2cb are sufficiently prevalent. Don't code new
+		software to look here, it should try /sys/fs/o2cb instead.
+		See Documentation/ABI/stable/o2cb for more information on usage.
+Users:		ocfs2-tools. It's sufficient to mail proposed changes to
+		ocfs2-devel at oss.oracle.com.
diff --git a/Documentation/ABI/stable/o2cb b/Documentation/ABI/stable/o2cb
new file mode 100644
index 0000000..5eb1545
--- /dev/null
+++ b/Documentation/ABI/stable/o2cb
@@ -0,0 +1,10 @@
+What:		/sys/fs/o2cb/ (was /sys/o2cb)
+Date:		Dec 2005
+KernelVersion:	2.6.16
+Contact:	ocfs2-devel at oss.oracle.com
+Description:	Ocfs2-tools looks at 'interface-revision' for versioning
+		information. Each logmask/ file controls a set of debug prints
+		and can be written into with the strings "allow", "deny", or
+		"off". Reading the file returns the current state.
+Users:		ocfs2-tools. It's sufficient to mail proposed changes to
+		ocfs2-devel at oss.oracle.com.
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bf0e3df..4101f1f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -318,3 +318,13 @@ Why:	Not used in-tree. The current out-of-tree users used it to
 	code / infrastructure should be in the kernel and not in some
 	out-of-tree driver.
 Who:	Thomas Gleixner <tglx@linutronix.de>
+
+---------------------------
+
+What:	/sys/o2cb symlink
+When:	January 2010
+Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
+	exists as a symlink for backwards compatibility for old versions of
+	ocfs2-tools. 2 years should be sufficient time to phase in new versions
+	which know to look in /sys/fs/o2cb.
+Who:	ocfs2-devel at oss.oracle.com
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 0c095ce..98429fd 100644
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
1.5.4.1
