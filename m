From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:40:56 +0000
Subject: [Ocfs2-devel] [PATCH 01/13] sysctl: add new
	register_sysctl_subdir() helper
In-Reply-To: <20200529074108.16928-1-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
Message-ID: <20200529074108.16928-2-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

Often enough all we need to do is create a subdirectory so that
we can stuff sysctls underneath it. However, *if* that directory
was already created early on the boot sequence we really have no
need to use the full boiler plate code for it, we can just use
local variables to help us guide sysctl to place the new leaf files.

So use a helper to do precisely this.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/sysctl.h | 11 +++++++++++
 kernel/sysctl.c        | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index ddaa06ddd852..58bc978d4f03 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -205,6 +205,9 @@ void unregister_sysctl_table(struct ctl_table_header * table);
 extern int sysctl_init(void);
 extern void register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name);
+extern struct ctl_table_header *register_sysctl_subdir(const char *base,
+						       const char *subdir,
+						       struct ctl_table *table);
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
@@ -223,6 +226,14 @@ static inline struct ctl_table_header *register_sysctl_table(struct ctl_table *
 	return NULL;
 }
 
+static
+inline struct ctl_table_header *register_sysctl_subdir(const char *base,
+						       const char *subdir,
+						       struct ctl_table *table)
+{
+	return NULL;
+}
+
 static inline struct ctl_table_header *register_sysctl_paths(
 			const struct ctl_path *path, struct ctl_table *table)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 008ac0576ae5..04ff032f2863 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -3195,6 +3195,43 @@ void __init register_sysctl_init(const char *path, struct ctl_table *table,
 	}
 	kmemleak_not_leak(hdr);
 }
+
+struct ctl_table_header *register_sysctl_subdir(const char *base,
+						const char *subdir,
+						struct ctl_table *table)
+{
+	struct ctl_table_header *hdr = NULL;
+	struct ctl_table subdir_table[] = {
+		{
+			.procname	= subdir,
+			.mode		= 0555,
+			.child		= table,
+		},
+		{ }
+	};
+	struct ctl_table base_table[] = {
+		{
+			.procname	= base,
+			.mode		= 0555,
+			.child		= subdir_table,
+		},
+		{ }
+	};
+
+	if (!table->procname)
+		goto out;
+
+	hdr = register_sysctl_table(base_table);
+	if (unlikely(!hdr)) {
+		pr_err("failed when creating subdirectory sysctl %s/%s/%s\n",
+		       base, subdir, table->procname);
+		goto out;
+	}
+	kmemleak_not_leak(hdr);
+out:
+	return hdr;
+}
+EXPORT_SYMBOL_GPL(register_sysctl_subdir);
 #endif /* CONFIG_SYSCTL */
 /*
  * No sense putting this after each symbol definition, twice,
-- 
2.26.2
