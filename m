From: Gang He <ghe@suse.com>
Date: Sun, 11 Sep 2016 20:03:42 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock on mmapped page in
 ocfs2_write_begin_nolock()
In-Reply-To: <1473501335-12519-1-git-send-email-zren@suse.com>
References: <1473501335-12519-1-git-send-email-zren@suse.com>
Message-ID: <57D67D7E020000F90004A0FC@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reviewed-by: Gang He <ghe@suse.com>

Thanks
Gang


>>> 
> The testcase "mmaptruncate" of ocfs2-test deadlocked occasionally.
> 
> In this testcase, we create a 2*CLUSTER_SIZE file and mmap() on it;
> there are 2 process repeatedly performing the following operations
> respectively: one is doing memset(mmaped_addr + 2*CLUSTER_SIZE - 1,
> 'a', 1), while the another is playing ftruncate(fd, 2*CLUSTER_SIZE)
> and then ftruncate(fd, CLUSTER_SIZE) again and again.
> 
> This is the backtrace when the deadlock happens:
> [<ffffffff817054f0>] __wait_on_bit_lock+0x50/0xa0
> [<ffffffff81199bd7>] __lock_page+0xb7/0xc0
> [<ffffffff810c4de0>] ? autoremove_wake_function+0x40/0x40
> [<ffffffffa0440f4f>] ocfs2_write_begin_nolock+0x163f/0x1790 [ocfs2]
> [<ffffffffa0462a50>] ? ocfs2_allocate_extend_trans+0x180/0x180 [ocfs2]
> [<ffffffffa0467b47>] ocfs2_page_mkwrite+0x1c7/0x2a0 [ocfs2]
> [<ffffffff811cf286>] do_page_mkwrite+0x66/0xc0
> [<ffffffff811d3635>] handle_mm_fault+0x685/0x1350
> [<ffffffff81039dc0>] ? __fpu__restore_sig+0x70/0x530
> [<ffffffff810694c8>] __do_page_fault+0x1d8/0x4d0
> [<ffffffff81069827>] trace_do_page_fault+0x37/0xf0
> [<ffffffff81061e69>] do_async_page_fault+0x19/0x70
> [<ffffffff8170ac98>] async_page_fault+0x28/0x30
> 
> In ocfs2_write_begin_nolock(), we first grab the pages and then
> allocate disk space for this write; ocfs2_try_to_free_truncate_log()
> will be called if ENOSPC is turned; if we're lucky to get enough clusters,
> which is usually the case, we start over again. But in 
> ocfs2_free_write_ctxt()
> the target page isn't unlocked, so we will deadlock when trying to grab
> the target page again.
> 
> Fix this issue by unlocking the target page after we fail to allocate
> enough space at the first time.
> 
> Jan Kara helps me clear out the JBD2 part, and suggest the hint for root 
> cause.
> 
> Signed-off-by: Eric Ren <zren@suse.com>
> ---
>  fs/ocfs2/aops.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 98d3654..78d1d67 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1860,6 +1860,13 @@ out:
>  		 */
>  		try_free = 0;
>  
> +		/*
> +		 * Unlock mmap_page because the page has been locked when we
> +		 * are here.
> +		 */
> +		if (mmap_page)
> +			unlock_page(mmap_page);
> +
>  		ret1 = ocfs2_try_to_free_truncate_log(osb, clusters_need);
>  		if (ret1 == 1)
>  			goto try_again;
> -- 
> 2.6.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
