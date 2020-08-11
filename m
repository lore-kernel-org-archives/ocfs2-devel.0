From: Joseph Qi <jiangqi903@gmail.com>
Date: Tue, 11 Aug 2020 10:35:21 +0800
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: delete repeated words in
 comments
In-Reply-To: <20200811021845.25134-1-rdunlap@infradead.org>
References: <20200811021845.25134-1-rdunlap@infradead.org>
Message-ID: <bae514ce-1cd6-0a60-9117-b8c7f2827940@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com



On 2020/8/11 10:18, Randy Dunlap wrote:
> Drop duplicated words {the, and} in comments.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: ocfs2-devel at oss.oracle.com

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c      |    2 +-
>  fs/ocfs2/localalloc.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20200807.orig/fs/ocfs2/alloc.c
> +++ linux-next-20200807/fs/ocfs2/alloc.c
> @@ -6013,7 +6013,7 @@ int __ocfs2_flush_truncate_log(struct oc
>  		goto out;
>  	}
>  
> -	/* Appending truncate log(TA) and and flushing truncate log(TF) are
> +	/* Appending truncate log(TA) and flushing truncate log(TF) are
>  	 * two separated transactions. They can be both committed but not
>  	 * checkpointed. If crash occurs then, both two transaction will be
>  	 * replayed with several already released to global bitmap clusters.
> --- linux-next-20200807.orig/fs/ocfs2/localalloc.c
> +++ linux-next-20200807/fs/ocfs2/localalloc.c
> @@ -677,7 +677,7 @@ int ocfs2_reserve_local_alloc_bits(struc
>  		/*
>  		 * Under certain conditions, the window slide code
>  		 * might have reduced the number of bits available or
> -		 * disabled the the local alloc entirely. Re-check
> +		 * disabled the local alloc entirely. Re-check
>  		 * here and return -ENOSPC if necessary.
>  		 */
>  		status = -ENOSPC;
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
