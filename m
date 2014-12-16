From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 16 Dec 2014 14:26:29 -0800
Subject: [Ocfs2-devel] [patch 04/15] ocfs2: avoid access invalid address
	when read	o2dlm debug messages
In-Reply-To: <548f65d4.jhly8vWOTpWuHPjg%akpm@linux-foundation.org>
References: <548f65d4.jhly8vWOTpWuHPjg%akpm@linux-foundation.org>
Message-ID: <20141216222629.GO7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:00PM -0800, Andrew Morton wrote:
> In such a race case, invalid address access may occurs.  So we should
> delete list res->tracking before resA->refs decrease to 0.
> 


> diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmmaster.c
> --- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
> +++ a/fs/ocfs2/dlm/dlmmaster.c
> @@ -498,16 +498,6 @@ static void dlm_lockres_release(struct k
>  	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
>  	     res->lockname.name);
>  
> -	spin_lock(&dlm->track_lock);
> -	if (!list_empty(&res->tracking))
> -		list_del_init(&res->tracking);
> -	else {
> -		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
> -		     res->lockname.len, res->lockname.name);
> -		dlm_print_one_lock_resource(res);
> -	}
> -	spin_unlock(&dlm->track_lock);
> -
>  	atomic_dec(&dlm->res_cur_count);
>  
>  	if (!hlist_unhashed(&res->hash_node) ||
> diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmthread.c
> --- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
> +++ a/fs/ocfs2/dlm/dlmthread.c
> @@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm
>  
>  	__dlm_unhash_lockres(dlm, res);
>  
> +	spin_lock(&dlm->track_lock);
> +	if (!list_empty(&res->tracking))
> +		list_del_init(&res->tracking);
> +	else {
> +		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
> +				res->lockname.len, res->lockname.name);
> +		__dlm_print_one_lock_resource(res);
> +	}
> +	spin_unlock(&dlm->track_lock);
> +
>  	/* lockres is not in the hash now.  drop the flag and wake up
>  	 * any processes waiting in dlm_get_lock_resource. */
>  	if (!master) {
> _

How do we know that dlm_purge_lockres() is the last caller of
dlm_lockres_put()? Don't we now have a problem where if the last ref is
dropped by any other function than dlm_purge_lockres() the lockres is freed
while on the tracking list?
	--Mark

--
Mark Fasheh
