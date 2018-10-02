From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 2 Oct 2018 15:43:47 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: dlm: Fix a
 sleep-in-atomic-context bug in dlm_print_one_mle()
In-Reply-To: <20180901112528.27025-1-baijiaju1990@gmail.com>
References: <20180901112528.27025-1-baijiaju1990@gmail.com>
Message-ID: <20181002154347.01e026b4e644d6b7efc76180@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sat,  1 Sep 2018 19:25:28 +0800 Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The kernel module may sleep with holding a spinlock.
> 
> The function call paths (from bottom to top) in Linux-4.16 are:
> 
> [FUNC] get_zeroed_page(GFP_NOFS)
> fs/ocfs2/dlm/dlmdebug.c, 332: get_zeroed_page in dlm_print_one_mle
> fs/ocfs2/dlm/dlmmaster.c, 240: dlm_print_one_mle in __dlm_put_mle
> fs/ocfs2/dlm/dlmmaster.c, 255: __dlm_put_mle in dlm_put_mle
> fs/ocfs2/dlm/dlmmaster.c, 254: spin_lock in dlm_put_ml
> 
> [FUNC] get_zeroed_page(GFP_NOFS)
> fs/ocfs2/dlm/dlmdebug.c, 332: get_zeroed_page in dlm_print_one_mle
> fs/ocfs2/dlm/dlmmaster.c, 240: dlm_print_one_mle in __dlm_put_mle
> fs/ocfs2/dlm/dlmmaster.c, 222: __dlm_put_mle in dlm_put_mle_inuse
> fs/ocfs2/dlm/dlmmaster.c, 219: spin_lock in dlm_put_mle_inuse
> 
> To fix this bug, GFP_NOFS is replaced with GFP_ATOMIC.
> 
> This bug is found by my static analysis tool DSAC.
> 
> ...
>
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -329,7 +329,7 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
>  {
>  	char *buf;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = (char *) get_zeroed_page(GFP_ATOMIC);
>  	if (buf) {
>  		dump_mle(mle, buf, PAGE_SIZE - 1);
>  		free_page((unsigned long)buf);

Fair enough.  It's pretty sad code here, replying on the page allocator
in this situation.  But it's only debug stuff so nobody is likely to
care much.

(And that page didn't need to be zeroed!)
