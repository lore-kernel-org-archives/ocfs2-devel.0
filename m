From: Joe Perches <joe@perches.com>
Date: Thu, 23 Apr 2015 16:35:21 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150423230418.GR17170@wotan.suse.de>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
	<20150423230418.GR17170@wotan.suse.de>
Message-ID: <1429832121.32612.43.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Thu, 2015-04-23 at 16:04 -0700, Mark Fasheh wrote:
> On Wed, Apr 22, 2015 at 03:46:04PM -0700, Andrew Morton wrote:
> > If you feel like undertaking such a rotorooting then go wild - that should
> > wake 'em up ;)
> 
> Ok, I've taken the bait  :)

"Here fishy, fishy...", erm, "Here Fasheh, Fasheh..."

With that out of the way:

A couple of possibilities:

o I wonder whether or not file/func/line matter at all.
  I think they don't.
  Removing them would reduce code size ~90K
o There's a small logging improvement possible in tcp.c.

Both below:

----------------------------------------------------------

 fs/ocfs2/cluster/masklog.c | 7 +++----
 fs/ocfs2/cluster/masklog.h | 8 +++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index fc5e522..8b9816f 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -77,8 +77,7 @@ static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
 	_cpu;								\
 })
 
-void __mlog_printk(const u64 *mask, const char *func, int line,
-		   const char *fmt, ...)
+void __mlog_printk(const u64 *mask, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -103,9 +102,9 @@ void __mlog_printk(const u64 *mask, const char *func, int line,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%s(%s,%u,%lu):%s:%d %s%pV",
+	printk("%s(%s,%u,%lu) %s%pV",
 	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
-	       func, line, prefix, &vaf);
+	       prefix, &vaf);
 
 	va_end(args);
 }
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 308ea0e..9e93f19 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -162,9 +162,8 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 
 #endif
 
-__printf(4, 5)
-void __mlog_printk(const u64 *m, const char *func, int line,
-		   const char *fmt, ...);
+__printf(2, 3)
+void __mlog_printk(const u64 *m, const char *fmt, ...);
 
 /*
  * Testing before the __mlog_printk call lets the compiler eliminate the
@@ -174,8 +173,7 @@ void __mlog_printk(const u64 *m, const char *func, int line,
 do {									\
 	u64 _m = MLOG_MASK_PREFIX | (mask);				\
 	if (_m & ML_ALLOWED_BITS)					\
-		__mlog_printk(&_m, __func__, __LINE__, fmt,		\
-			      ##__VA_ARGS__);				\
+		__mlog_printk(&_m, fmt, ##__VA_ARGS__);			\
 } while (0)
 
 #define mlog_errno(st) ({						\

----------------------------------------------------------

 fs/ocfs2/cluster/tcp.c | 60 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 56c403a..2c74973 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -78,29 +78,43 @@
 			  &sc->sc_node->nd_ipv4_address,		\
 			  ntohs(sc->sc_node->nd_ipv4_port)
 
-/*
- * In the following two log macros, the whitespace after the ',' just
- * before ##args is intentional. Otherwise, gcc 2.95 will eat the
- * previous token if args expands to nothing.
- */
-#define msglog(hdr, fmt, args...) do {					\
-	typeof(hdr) __hdr = (hdr);					\
-	mlog(ML_MSG, "[mag %u len %u typ %u stat %d sys_stat %d "	\
-	     "key %08x num %u] " fmt,					\
-	     be16_to_cpu(__hdr->magic), be16_to_cpu(__hdr->data_len), 	\
-	     be16_to_cpu(__hdr->msg_type), be32_to_cpu(__hdr->status),	\
-	     be32_to_cpu(__hdr->sys_status), be32_to_cpu(__hdr->key),	\
-	     be32_to_cpu(__hdr->msg_num) ,  ##args);			\
-} while (0)
-
-#define sclog(sc, fmt, args...) do {					\
-	typeof(sc) __sc = (sc);						\
-	mlog(ML_SOCKET, "[sc %p refs %d sock %p node %u page %p "	\
-	     "pg_off %zu] " fmt, __sc,					\
-	     atomic_read(&__sc->sc_kref.refcount), __sc->sc_sock,	\
-	    __sc->sc_node->nd_num, __sc->sc_page, __sc->sc_page_off ,	\
-	    ##args);							\
-} while (0)
+__printf(2, 3)
+void msglog(struct o2net_msg *hdr, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	mlog(ML_MSG, "[mag %u len %u typ %u stat %d sys_stat %d key %08x num %u] %pV",
+	     be16_to_cpu(hdr->magic), be16_to_cpu(hdr->data_len),
+	     be16_to_cpu(hdr->msg_type), be32_to_cpu(hdr->status),
+	     be32_to_cpu(hdr->sys_status), be32_to_cpu(hdr->key),
+	     be32_to_cpu(hdr->msg_num), &vaf);
+
+	va_end(args);
+}
+
+__printf(2, 3)
+void sclog(struct o2net_sock_container *sc, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	mlog(ML_SOCKET, "[sc %p refs %d sock %p node %u page %p pg_off %zu] %pV",
+	     sc, atomic_read(&sc->sc_kref.refcount), sc->sc_sock,
+	     sc->sc_node->nd_num, sc->sc_page, sc->sc_page_off, &vaf);
+
+	va_end(args);
+}
 
 static DEFINE_RWLOCK(o2net_handler_lock);
 static struct rb_root o2net_handler_tree = RB_ROOT;
