From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:25 -0800
Subject: [Ocfs2-devel] [PATCH 04/18] ocfs2/cluster: Handle different
	prototype of bi_end_io_t
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 6712ecf8f648118c3363c142196418f89a510b90 dropped the 'size'
argument from bi_end_io_t. Also changed the return from int to void. Patch
uses the older prototype when building with EL5 kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in               |    1 +
 configure.in                 |    5 +++++
 fs/ocfs2/cluster/Makefile    |    4 ++++
 fs/ocfs2/cluster/heartbeat.c |    7 +++++++
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index fb705b5..618c814 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -73,6 +73,7 @@ SEQOP_IS_NOT_CONST = @SEQOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 OLD_PERMISSION = @OLD_PERMISSION@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
+OLD_BIO_END_IO_T = @OLD_BIO_END_IO_T@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 98cdc5d..8696935 100644
--- a/configure.in
+++ b/configure.in
@@ -334,6 +334,11 @@ OCFS2_CHECK_KERNEL([	older prototype of kmem_cache_create() in slab.h], slab.h,
 AC_SUBST(KMEM_CACHE_CREATE_DTOR)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $KMEM_CACHE_CREATE_DTOR"
 
+OLD_BIO_END_IO_T=
+OCFS2_CHECK_KERNEL([	older prototype of bio_end_io_t in bio.h], bio.h,
+  OLD_BIO_END_IO_T=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
+AC_SUBST(OLD_BIO_END_IO_T)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index 1f040c6..d107cca 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -26,6 +26,10 @@ ifdef SEQOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSEQOP_IS_NOT_CONST
 endif
 
+ifdef OLD_BIO_END_IO_T
+EXTRA_CFLAGS += -DOLD_BIO_END_IO_T
+endif
+
 SOURCES +=			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 68e9af5..d07241f 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -221,7 +221,11 @@ static void o2hb_wait_on_io(struct o2hb_region *reg,
 	wait_for_completion(&wc->wc_io_complete);
 }
 
+#ifdef OLD_BIO_END_IO_T
+static int o2hb_bio_end_io(struct bio *bio, unsigned int size,
+#else
 static void o2hb_bio_end_io(struct bio *bio,
+#endif
 			   int error)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
@@ -233,6 +237,9 @@ static void o2hb_bio_end_io(struct bio *bio,
 
 	o2hb_bio_wait_dec(wc, 1);
 	bio_put(bio);
+#ifdef OLD_BIO_END_IO_T
+	return 0;
+#endif
 }
 
 /* Setup a Bio to cover I/O against num_slots slots starting at
-- 
1.5.6.5
