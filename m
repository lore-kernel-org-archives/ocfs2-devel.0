From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 18 Nov 2009 14:26:47 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return -EAGAIN instead of
 EAGAIN in dlm
In-Reply-To: <1258540528-3377-1-git-send-email-tiger.yang@oracle.com>
References: <1258540528-3377-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <4B0474A7.9020506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

comments inlined

Tiger Yang wrote:
> We used to return positive EAGAIN to indicate a retry action
> is needed in dlm_begin_reco_handler(). Now we use negative -EAGAIN
> to erase the confusion caused by this error code.
>
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index d9fa3d2..8818c8c 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2589,6 +2589,15 @@ retry:
>  			     "begin reco msg (%d)\n", dlm->name, nodenum, ret);
>  			ret = 0;
>  		}
> +		if (ret == -EAGAIN) {
> +			mlog(0, "%s: trying to start recovery of node "
> +			     "%u, but node %u is waiting for last recovery "
> +			     "to complete, backoff for a bit\n", dlm->name,
> +			     dead_node, nodenum);
> +			/*TODO Look into replacing msleep with cond_resched()*/

This comment can be removed. We cannot replace the msleep with 
cond_resched().
If anything we may want to increase the msleep to 1 sec. But leave that 
as is for now.

> +			msleep(100);
> +			goto retry;
> +		}
>  		if (ret < 0) {
>  			struct dlm_lock_resource *res;
>  			/* this is now a serious problem, possibly ENOMEM 
> @@ -2608,14 +2617,6 @@ retry:
>  			 * another ENOMEM */
>  			msleep(100);
>  			goto retry;
> -		} else if (ret == EAGAIN) {
> -			mlog(0, "%s: trying to start recovery of node "
> -			     "%u, but node %u is waiting for last recovery "
> -			     "to complete, backoff for a bit\n", dlm->name,
> -			     dead_node, nodenum);
> -			/* TODO Look into replacing msleep with cond_resched() */
> -			msleep(100);
> -			goto retry;
>  		}
>  	}
>  
> @@ -2639,7 +2640,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  		     dlm->name, br->node_idx, br->dead_node,
>  		     dlm->reco.dead_node, dlm->reco.new_master);
>  		spin_unlock(&dlm->spinlock);
> -		return EAGAIN;
> +		return -EAGAIN;
>  	}
>  	spin_unlock(&dlm->spinlock);
>  

This looks sane. Though I would like someone else to review it too as we
have no real way of testing this.
