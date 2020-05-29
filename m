From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:41:07 +0000
Subject: [Ocfs2-devel] [PATCH 12/13] sysctl: add helper to register empty
	subdir
In-Reply-To: <20200529074108.16928-1-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
Message-ID: <20200529074108.16928-13-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

The way to create a subdirectory from the base set of directories
is a bit obscure, so provide a helper which makes this clear, and
also helps remove boiler plate code required to do this work.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/sysctl.h |  7 +++++++
 kernel/sysctl.c        | 16 +++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 33a471b56345..89c92390e6de 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -208,6 +208,8 @@ extern void register_sysctl_init(const char *path, struct ctl_table *table,
 extern struct ctl_table_header *register_sysctl_subdir(const char *base,
 						       const char *subdir,
 						       struct ctl_table *table);
+extern void register_sysctl_empty_subdir(const char *base, const char *subdir);
+
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
@@ -231,6 +233,11 @@ inline struct ctl_table_header *register_sysctl_subdir(const char *base,
 	return NULL;
 }
 
+static inline void register_sysctl_empty_subdir(const char *base,
+						const char *subdir)
+{
+}
+
 static inline struct ctl_table_header *register_sysctl_paths(
 			const struct ctl_path *path, struct ctl_table *table)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f9a35325d5d5..460532cd5ac8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -3188,13 +3188,17 @@ struct ctl_table_header *register_sysctl_subdir(const char *base,
 		{ }
 	};
 
-	if (!table->procname)
+	if (table != sysctl_mount_point && !table->procname)
 		goto out;
 
 	hdr = register_sysctl_table(base_table);
 	if (unlikely(!hdr)) {
-		pr_err("failed when creating subdirectory sysctl %s/%s/%s\n",
-		       base, subdir, table->procname);
+		if (table != sysctl_mount_point)
+			pr_err("failed when creating subdirectory sysctl %s/%s/%s\n",
+			       base, subdir, table->procname);
+		else
+			pr_err("failed when creating empty subddirectory %s/%s\n",
+			       base, subdir);
 		goto out;
 	}
 	kmemleak_not_leak(hdr);
@@ -3202,6 +3206,12 @@ struct ctl_table_header *register_sysctl_subdir(const char *base,
 	return hdr;
 }
 EXPORT_SYMBOL_GPL(register_sysctl_subdir);
+
+void register_sysctl_empty_subdir(const char *base,
+				  const char *subdir)
+{
+	register_sysctl_subdir(base, subdir, sysctl_mount_point);
+}
 #endif /* CONFIG_SYSCTL */
 /*
  * No sense putting this after each symbol definition, twice,
-- 
2.26.2
