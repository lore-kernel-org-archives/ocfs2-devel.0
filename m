From: Zhen Ren <zren@suse.com>
Date: Tue, 19 Jan 2016 19:35:39 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmglue: fix false deadlock caused
 by clearing UPCONVERT_FINISHING too early
In-Reply-To: <1453222013-9425-1-git-send-email-zren@suse.com>
References: <1453222013-9425-1-git-send-email-zren@suse.com>
Message-ID: <569F62FB020000D40000CA16@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Very sorry, this fix is wrong, becuase it can ensure waking up every waiter, but cannot
guarantee every waiter finish trying its "again" patch in __ocfs2_cluster_lock().

Other solutions now on my mind are:
1. Give every waiter an ID. When clearing OCFS2_LOCK_BUSY, we can record those IDs
in an array. Process any waiter in mask-waiter list, remove the ID from the arry
if its ID is in the array, util array is empty we can then clear
OCFS2_LOCK_UPCONVERT_FINISHING.

I think it's a bad idea. It's inefficient to handle the array and the ID control is
another problem.

2. Split mask-waiter list into two lists: one for OCFS2_LOCK_BUSY, and another for
OCFS2_LOCK_BLOCKED. When OCFS2_LOCK_BUSY being cleared and OCFS2_LOCK_BLOCKED being
set, we should process waiters in BUSY list and move waiters who cannot get the lock into
BLOCKED list again. And when OCFS2_LOCK_BLOCKED being cleared and OCFS2_LOCK_BUSY being
set, we should do things like that.

But is any chance that both OCFS2_LOCK_BUSY and OCFS2_LOCK_BLOCKED are set at the same time?
If not, I prefer this one.

What do you think? Any comment would be appreciated.

Thanks,
Eric

 >>>
> This problem was introduced by commit  
> a19128260107f951d1b4c421cf98b92f8092b069. 
> OCFS2_LOCK_UPCONVERT_FINISHING is set just before clearing OCFS2_LOCK_BUSY.  
> This 
> will prevent dc thread from downconverting immediately, and let mask-waiters  
> in 
> ->l_mask_waiters list whose requesting level is compatible with ->l_level to  
> take 
> the lock. But if we have two waiters in mw list, the first is to get EX  
> lock, and 
> the second is to to get PR lock. The first may fail to get lock and then  
> clear 
> UPCONVERT_FINISHING. It's too early to clear the flag because this second  
> will be 
> also queued again even if ->l_level is PR. As a result, nobody would kick up  
> dc 
> thread, leaving dlmglue a deadlock until another lockres relative thread  
> wake it 
> up. 
>  
> More specifically, for example: 
> On node1, there is thread W1 keeping writing; on node2, there are thread R1  
> and 
> R2 keeping reading; sure this 3 threads make IO on the same shared file. At  
> a 
> time, node2 is receiving ast(0=>3), followed immediately by a bast requesting  
> EX 
> lock on behave of node1. Then this may happen: 
> node2:                                          node1: 
> l_level==3; R1(3); R2(3)                        l_level==3 
> R1(unlock); R1(3=>5, update atime)              W1(3=>5) 
> BAST 
> R2(unlock); AST(3=>0) 
> R2(0=>3) 
>                                                 BAST 
> AST(0=>3) 
> set OCFS2_LOCK_UPCONVERT_FINISHING 
> clear OCFS2_LOCK_BUSY 
>                                                 W1(3=>5) 
> BAST 
> dc thread requeue=yes 
> R1(clear OCFS2_LOCK_UPCONVERT_FINISHING,wait) 
> R2(wait) 
> ... 
> dlmglue deadlock util dc thread woken up by others 
>  
> This fix is to clear OCFS2_LOCK_UPCONVERT_FINISHING util OCFS2_LOCK_BUSY has 
> been cleared and every waiters has been looped. 
>  
> Signed-off-by: Eric Ren <zren@suse.com> 
> --- 
>  fs/ocfs2/dlmglue.c | 4 ++-- 
>  1 file changed, 2 insertions(+), 2 deletions(-) 
>  
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c 
> index f92612e..72f8b6c 100644 
> --- a/fs/ocfs2/dlmglue.c 
> +++ b/fs/ocfs2/dlmglue.c 
> @@ -824,6 +824,8 @@ static void lockres_clear_flags(struct ocfs2_lock_res  
> *lockres, 
>  				unsigned long clear) 
>  { 
>  	lockres_set_flags(lockres, lockres->l_flags & ~clear); 
> +	if(clear & OCFS2_LOCK_BUSY) 
> +		lockres->l_flags &= ~OCFS2_LOCK_UPCONVERT_FINISHING; 
>  } 
>   
>  static inline void ocfs2_generic_handle_downconvert_action(struct  
> ocfs2_lock_res *lockres) 
> @@ -1522,8 +1524,6 @@ update_holders: 
>   
>  	ret = 0; 
>  unlock: 
> -	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING); 
> - 
>  	spin_unlock_irqrestore(&lockres->l_lock, flags); 
>  out: 
>  	/* 
 
