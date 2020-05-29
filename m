From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:41:02 +0000
Subject: [Ocfs2-devel] [PATCH 07/13] test_sysctl: use new sysctl subdir
	helper register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-1-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
Message-ID: <20200529074108.16928-8-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

This simplifies the code considerably. The following coccinelle
SmPL grammar rule was used to transform this code.

// pycocci sysctl-subdir.cocci lib/test_sysctl.c

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
 lib/test_sysctl.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index 84eaae22d3a6..b17581307756 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -128,26 +128,6 @@ static struct ctl_table test_table[] = {
 	{ }
 };
 
-static struct ctl_table test_sysctl_table[] = {
-	{
-		.procname	= "test_sysctl",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= test_table,
-	},
-	{ }
-};
-
-static struct ctl_table test_sysctl_root_table[] = {
-	{
-		.procname	= "debug",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= test_sysctl_table,
-	},
-	{ }
-};
-
 static struct ctl_table_header *test_sysctl_header;
 
 static int __init test_sysctl_init(void)
@@ -155,7 +135,8 @@ static int __init test_sysctl_init(void)
 	test_data.bitmap_0001 = kzalloc(SYSCTL_TEST_BITMAP_SIZE/8, GFP_KERNEL);
 	if (!test_data.bitmap_0001)
 		return -ENOMEM;
-	test_sysctl_header = register_sysctl_table(test_sysctl_root_table);
+	test_sysctl_header = register_sysctl_subdir("debug", "test_sysctl",
+						    test_table);
 	if (!test_sysctl_header) {
 		kfree(test_data.bitmap_0001);
 		return -ENOMEM;
-- 
2.26.2
