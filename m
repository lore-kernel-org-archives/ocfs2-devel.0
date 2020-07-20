From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 20 Jul 2020 09:17:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: suballoc.h: delete a duplicated
	word
In-Reply-To: <20200720001421.28823-1-rdunlap@infradead.org>
References: <20200720001421.28823-1-rdunlap@infradead.org>
Message-ID: <540ab401-d7a3-1b94-7acf-3852ce2292b7@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>



On 2020/7/20 08:14, Randy Dunlap wrote:
> Drop the repeated word "is" in a comment.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel at oss.oracle.com

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/suballoc.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20200717.orig/fs/ocfs2/suballoc.h
> +++ linux-next-20200717/fs/ocfs2/suballoc.h
> @@ -40,7 +40,7 @@ struct ocfs2_alloc_context {
>  
>  	u64    ac_last_group;
>  	u64    ac_max_block;  /* Highest block number to allocate. 0 is
> -				 is the same as ~0 - unlimited */
> +				 the same as ~0 - unlimited */
>  
>  	int    ac_find_loc_only;  /* hack for reflink operation ordering */
>  	struct ocfs2_suballoc_result *ac_find_loc_priv; /* */
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
