From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 25 Feb 2020 08:53:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing annotations for
 ocfs2_refcount_cache_lock() and ocfs2_refcount_cache_unlock()
In-Reply-To: <20200224204130.18178-1-jbi.octave@gmail.com>
References: <20200224204130.18178-1-jbi.octave@gmail.com>
Message-ID: <0f1b869e-080a-2785-e4c1-01f308f246bb@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com
Cc: joseph.qi@linux.alibab.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, "moderated list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@oss.oracle.com>, open list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>



On 2020/2/25 04:41, Jules Irenge wrote:
> Sparse reports warnings at ocfs2_refcount_cache_lock()
> 	and ocfs2_refcount_cache_unlock()
> 
> warning: context imbalance in ocfs2_refcount_cache_lock()
> 	- wrong count at exit
> warning: context imbalance in ocfs2_refcount_cache_unlock()
> 	- unexpected unlock
> 
> The root cause is the missing annotation at ocfs2_refcount_cache_lock()
> 	and at ocfs2_refcount_cache_unlock()
> 
> Add the missing __acquires(&rf->rf_lock) annotation
> 	to ocfs2_refcount_cache_lock()
> Add the missing __releases(&rf->rf_lock) annotation
> 	to ocfs2_refcount_cache_unlock()
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/refcounttree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index ee43e51188be..da99c80f49da 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -154,6 +154,7 @@ ocfs2_refcount_cache_get_super(struct ocfs2_caching_info *ci)
>  }
>  
>  static void ocfs2_refcount_cache_lock(struct ocfs2_caching_info *ci)
> +	__acquires(&rf->rf_lock)
>  {
>  	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
>  
> @@ -161,6 +162,7 @@ static void ocfs2_refcount_cache_lock(struct ocfs2_caching_info *ci)
>  }
>  
>  static void ocfs2_refcount_cache_unlock(struct ocfs2_caching_info *ci)
> +	__releases(&rf->rf_lock)
>  {
>  	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
>  
> 
