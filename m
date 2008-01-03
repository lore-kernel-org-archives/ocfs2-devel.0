From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:51 2008
Subject: [Ocfs2-devel] [PATCH 29/30] ocfs2: Handle older prototype of
	bi_end_io_t
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-28-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 6712ecf8f648118c3363c142196418f89a510b90 in mainline
dropped 'size' argument from bi_end_io(). This patch allows
one to build ocfs2 with kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in               |    1 +
 configure.in                 |    5 +++++
 fs/ocfs2/cluster/Makefile    |    4 ++++
 fs/ocfs2/cluster/heartbeat.c |    9 +++++++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 114cf90..98577c6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -74,6 +74,7 @@ SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
+OLD_BIO_END_IO = @OLD_BIO_END_IO@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index b1e7be6..a55db86 100644
--- a/configure.in
+++ b/configure.in
@@ -296,6 +296,11 @@ OCFS2_CHECK_KERNEL([__splice_from_pipe() in splice.h], splice.h,
   , NO_SPLICE_FROM_PIPE=yes, [^extern ssize_t __splice_from_pipe(struct pipe_inode_info \*])
 AC_SUBST(NO_SPLICE_FROM_PIPE)
 
+OLD_BIO_END_IO=
+OCFS2_CHECK_KERNEL([old bio_end_io_t in bio.h], bio.h,
+  OLD_BIO_END_IO=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
+AC_SUBST(OLD_BIO_END_IO)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index 512bfa1..0a5e287 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -29,6 +29,10 @@ ifdef STRUCT_SUBSYSTEM_DEFINED
 EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
 endif
 
+ifdef OLD_BIO_END_IO
+EXTRA_CFLAGS += -DOLD_BIO_END_IO
+endif
+
 SOURCES =			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 65ff7f3..6a91607 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -215,8 +215,14 @@ static void o2hb_wait_on_io(struct o2hb_region *reg,
 	wait_for_completion(&wc->wc_io_complete);
 }
 
+#ifdef OLD_BIO_END_IO
+static int o2hb_bio_end_io(struct bio *bio,
+			   unsigned int bytes_done,
+			   int error)
+#else
 static void o2hb_bio_end_io(struct bio *bio,
 			   int error)
+#endif
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
 
@@ -227,6 +233,9 @@ static void o2hb_bio_end_io(struct bio *bio,
 
 	o2hb_bio_wait_dec(wc, 1);
 	bio_put(bio);
+#ifdef OLD_BIO_END_IO
+	return 0;
+#endif
 }
 
 /* Setup a Bio to cover I/O against num_slots slots starting at
-- 
1.5.2.5
