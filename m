From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 17 Nov 2010 09:49:34 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <AANLkTinAb5TvZNiYPwP8+L5_m-j-zDs6+zbdCTLW45Jg@mail.gmail.com>
References: <AANLkTinAb5TvZNiYPwP8+L5_m-j-zDs6+zbdCTLW45Jg@mail.gmail.com>
Message-ID: <20101117014934.GC2289@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-16 16:59, Goldwyn Rodrigues wrote:

<snip>
> @@ -212,8 +198,8 @@ static int ocfs2_recovery_thread_running(struct
> ocfs2_super *osb)
> 
>  void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  {
> -	struct ocfs2_recovery_map *rm;
> -
> +	struct list_head *iter;
> +	struct ocfs2_recover_node *rn;
>  	/* disable any new recovery threads and wait for any currently
>  	 * running ones to exit. Do this before setting the vol_state. */
>  	mutex_lock(&osb->recovery_lock);
> @@ -226,75 +212,66 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  	 * complete. */
>  	flush_workqueue(ocfs2_wq);
> 
> -	/*
> -	 * Now that recovery is shut down, and the osb is about to be
> -	 * freed,  the osb_lock is not taken here.
> -	 */
> -	rm = osb->recovery_map;
> -	/* XXX: Should we bug if there are dirty entries? */
> -
> -	kfree(rm);
> +	spin_lock(&osb->osb_lock);
> +	list_for_each(iter, &osb->s_recovery_nodes) {

list_for_each_safe()?

regards,
wengang.
> +			rn = list_entry(iter, struct ocfs2_recover_node,
> +					rn_list);
> +			list_del(&rn->rn_list);
> +	}
> +	spin_unlock(&osb->osb_lock);
>  }
> 
