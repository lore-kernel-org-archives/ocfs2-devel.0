From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Aug 2015 13:57:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: direct write will call
 ocfs2_rw_unlock() twice when doing aio+dio
In-Reply-To: <55DACA18.9020103@oracle.com>
References: <1440400995-6399-1-git-send-email-ryan.ding@oracle.com>
	<55DACA18.9020103@oracle.com>
Message-ID: <20150824135711.d8dde78d656497fda4544898@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 24 Aug 2015 15:39:04 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> On 08/24/2015 03:23 PM, Ryan Ding wrote:
> > Orabug: 21612107
> > 
> > Use wrong return value in ocfs2_file_write_iter(). This will cause
> > ocfs2_rw_unlock() be called both in write_iter & end_io, and trigger a BUG_ON.
> > 
> > This issue exist since commit 7da839c475894ea872ec909a5d2e83dddccff5be.
> Better say:
> This issue is introduced by commit 7da839c47589 ("ocfs2: use
> __generic_file_write_iter()") , or checkpatch will report a style error.
> Other looks good.
> 
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> 

Also we've recently adopted the convention of using the "Fixes:" tag:
Fixes: 7da839c47589 ("ocfs2: use __generic_file_write_iter()")

And as the patch fixes a regression we should add the "Cc:
<stable@vger.kernel.org>" tag.

And we should the author of the bad patch for review (hi, Al).

I've made these changes and I'll get this patch into Linus this week,
for 4.2.


From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: direct write will call ocfs2_rw_unlock() twice when doing aio+dio

Orabug: 21612107

ocfs2_file_write_iter() is usng the wrong return value ('written').  This
will cause ocfs2_rw_unlock() be called both in write_iter & end_io,
triggering a BUG_ON.

This issue was introduced by commit 7da839c47589 ("ocfs2: use
__generic_file_write_iter()").

Fixes: 7da839c47589 ("ocfs2: use __generic_file_write_iter()")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-direct-write-will-call-ocfs2_rw_unlock-twice-when-doing-aiodio
+++ a/fs/ocfs2/file.c
@@ -2366,6 +2366,20 @@ relock:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(written == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
 
+	/*
+	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
+	 * function pointer which is called when o_direct io completes so that
+	 * it can unlock our rw lock.
+	 * Unfortunately there are error cases which call end_io and others
+	 * that don't.  so we don't have to unlock the rw_lock if either an
+	 * async dio is going to do it in the future or an end_io after an
+	 * error has already done it.
+	 */
+	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
+		rw_level = -1;
+		unaligned_dio = 0;
+	}
+
 	if (unlikely(written <= 0))
 		goto no_sync;
 
@@ -2390,20 +2404,6 @@ relock:
 	}
 
 no_sync:
-	/*
-	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
-	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.
-	 * Unfortunately there are error cases which call end_io and others
-	 * that don't.  so we don't have to unlock the rw_lock if either an
-	 * async dio is going to do it in the future or an end_io after an
-	 * error has already done it.
-	 */
-	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
-		rw_level = -1;
-		unaligned_dio = 0;
-	}
-
 	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
_
