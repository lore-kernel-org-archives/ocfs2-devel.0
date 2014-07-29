From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 29 Jul 2014 16:47:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix journal commit deadlock
In-Reply-To: <20140728164012.e4c201a4b8c1512468909eaa@linux-foundation.org>
References: <1406192280-6643-1-git-send-email-junxiao.bi@oracle.com>
	<20140728164012.e4c201a4b8c1512468909eaa@linux-foundation.org>
Message-ID: <53D75F86.5040109@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 07/29/2014 07:40 AM, Andrew Morton wrote:
> On Thu, 24 Jul 2014 16:58:00 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
>> For buffer write, page lock will be got in write_begin and released
>> in write_end, in ocfs2_write_end_nolock(), before it unlock the page
>> in ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will
>> ask for the read lock of journal->j_trans_barrier. Holding page lock
>> and ask for journal->j_trans_barrier breaks the locking order.
>>
>> This will cause a deadlock with journal commit threads, ocfs2cmt will
>> get write lock of journal->j_trans_barrier first, then it wakes up
>> kjournald2 to do the commit work, at last it waits until done. To
>> commit journal, kjournald2 needs flushing data first, it needs get
>> the cache page lock.
>>
>> Since some ocfs2 cluster locks are holding by write process, this
>> deadlock may hung the whole cluster.
>>
>> unlock pages before ocfs2_run_deallocs() can fix the locking order,
>> also put unlock before ocfs2_commit_trans() to make page lock is
>> unlocked before j_trans_barrier to preserve unlocking order.
> This conflicts with
> http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
> in ways which I am not confident in resolving.  Could you please redo
> the patch against linux-next and retest?
Resolved. See the following fix.

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a06b237..2e63621 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -894,7 +894,7 @@ void ocfs2_unlock_and_free_pages(struct page
**pages, int num_pages)
        }
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
        int i;
 
@@ -915,7 +915,11 @@ static void ocfs2_free_write_ctxt(struct
ocfs2_write_ctxt *wc)
                page_cache_release(wc->w_target_page);
        }
        ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+}
 
+static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+       ocfs2_unlock_pages(wc);
        brelse(wc->w_di_bh);
        kfree(wc);
 }
@@ -2040,11 +2044,19 @@ out_write_size:
        ocfs2_journal_dirty(handle, wc->w_di_bh);
 
 out:
+       /* unlock pages before dealloc since it needs acquiring
j_trans_barrier
+        * lock, or it will cause a deadlock since journal commit
threads holds
+        * this lock and will ask for the page lock when flushing the data.
+        * put it here to preserve the unlock order.
+        */
+       ocfs2_unlock_pages(wc);
+
        ocfs2_commit_trans(osb, handle);
 
        ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
-       ocfs2_free_write_ctxt(wc);
+       brelse(wc->w_di_bh);
+       kfree(wc);
 
        return copied;
 }

Thanks,
Junxiao.


>
