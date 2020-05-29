From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:40:59 +0000
Subject: [Ocfs2-devel] [PATCH 04/13] i915: use new sysctl subdir helper
	register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-1-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
Message-ID: <20200529074108.16928-5-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

This simplifies the code considerably. The following coccinelle
SmPL grammar rule was used to transform this code.

// pycocci sysctl-subdir.cocci drivers/gpu/drm/i915/i915_perf.c

@c1@
expression E1;
identifier subdir, sysctls;
@@

static struct ctl_table subdir[] = {
	{
		.procname = E1,
		.maxlen = 0,
		.mode = 0555,
		.child = sysctls,
	},
	{ }
};

@c2@
identifier c1.subdir;

expression E2;
identifier base;
@@

static struct ctl_table base[] = {
	{
		.procname = E2,
		.maxlen = 0,
		.mode = 0555,
		.child = subdir,
	},
	{ }
};

@c3@
identifier c2.base;
identifier header;
@@

header = register_sysctl_table(base);

@r1 depends on c1 && c2 && c3@
expression c1.E1;
identifier c1.subdir, c1.sysctls;
@@

-static struct ctl_table subdir[] = {
-	{
-		.procname = E1,
-		.maxlen = 0,
-		.mode = 0555,
-		.child = sysctls,
-	},
-	{ }
-};

@r2 depends on c1 && c2 && c3@
identifier c1.subdir;

expression c2.E2;
identifier c2.base;
@@
-static struct ctl_table base[] = {
-	{
-		.procname = E2,
-		.maxlen = 0,
-		.mode = 0555,
-		.child = subdir,
-	},
-	{ }
-};

@r3 depends on c1 && c2 && c3@
expression c1.E1;
identifier c1.sysctls;
expression c2.E2;
identifier c2.base;
identifier c3.header;
@@

header =
-register_sysctl_table(base);
+register_sysctl_subdir(E2, E1, sysctls);

Generated-by: Coccinelle SmPL
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 665bb076e84d..52509b573794 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4203,26 +4203,6 @@ static struct ctl_table oa_table[] = {
 	{}
 };
 
-static struct ctl_table i915_root[] = {
-	{
-	 .procname = "i915",
-	 .maxlen = 0,
-	 .mode = 0555,
-	 .child = oa_table,
-	 },
-	{}
-};
-
-static struct ctl_table dev_root[] = {
-	{
-	 .procname = "dev",
-	 .maxlen = 0,
-	 .mode = 0555,
-	 .child = i915_root,
-	 },
-	{}
-};
-
 /**
  * i915_perf_init - initialize i915-perf state on module bind
  * @i915: i915 device instance
@@ -4383,7 +4363,7 @@ static int destroy_config(int id, void *p, void *data)
 
 void i915_perf_sysctl_register(void)
 {
-	sysctl_header = register_sysctl_table(dev_root);
+	sysctl_header = register_sysctl_subdir("dev", "i915", oa_table);
 }
 
 void i915_perf_sysctl_unregister(void)
-- 
2.26.2
