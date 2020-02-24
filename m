From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 24 Feb 2020 09:52:39 +0800
Subject: [Ocfs2-devel] [PATCH 30/30] sgi-xp: Add missing annotation for
 ocfs2_inode_cache_lock() and ocfs2_inode_cache_unlock()
In-Reply-To: <20200223231711.157699-31-jbi.octave@gmail.com>
References: <0/30> <20200223231711.157699-1-jbi.octave@gmail.com>
	<20200223231711.157699-31-jbi.octave@gmail.com>
Message-ID: <fd7abad1-1bbe-8dc7-3aef-2ab5b4c359bf@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, "moderated list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@oss.oracle.com>, Andrew Morton <akpm@linux-foundation.org>



On 2020/2/24 07:17, Jules Irenge wrote:
> Sparse reports a warning at ocfs2_inode_cache_lock()
> and ocfs2_inode_cache_unlock()
> warning: context imbalance in ocfs2_inode_cache_lock()
> 	- wrong count at exit
> 
> warning: context imbalance in ocfs2_inode_cache_unlock()
> 	- unexpected unlock
> The root cause is a missing annotation at ocfs2_inode_cache_lock()
> and at ocfs2_inode_cache_unlock()
> 
> Add the missing __acquires(&oi->ip_lock) annotation
> Add the missing __releases(&oi->ip_lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Looks good.
BTW, there are another co_cache_[lock|unlock] implementations also
miss the annotations:
ocfs2_refcount_cache_lock
ocfs2_refcount_cache_unlock
So could we add the missing annotations as well?

Thanks,
Joseph

> ---
>  fs/ocfs2/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 7c9dfd50c1c1..0b87e0a63ab9 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1623,6 +1623,7 @@ static struct super_block *ocfs2_inode_cache_get_super(struct ocfs2_caching_info
>  }
>  
>  static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
> +	__acquires(&oi->ip_lock)
>  {
>  	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
>  
> @@ -1630,6 +1631,7 @@ static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
>  }
>  
>  static void ocfs2_inode_cache_unlock(struct ocfs2_caching_info *ci)
> +	__releases(&oi->ip_lock)
>  {
>  	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
>  
> 
