Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B2101FD
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Aug 2023 11:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C8BC433C7;
	Wed, 16 Aug 2023 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692185865;
	bh=RL4m4ONn3JQ2aJBR+dWTncFryUjjHtRlbcL+rnTLBJQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ElSdhCW2SgW0LGYw1qdRbeF4aaUkZTfSbwgJkNzEQi74ozYVNsp5Yf/XjHj+oN0Dl
	 1R1og3BX4xR2gOeZuvgQwISBZhJ+Bs9WaMyhPamZNfQqhqy6dlD+/BKWWzFye0brrV
	 sMdkjuOZ172KF9MPA14XyxQJu+nu5k+PJxZpYUCyYeSD24IxlN2MH0slrbD6gLFrO+
	 dd/93H3icHfSQyKMZ1wGf35vP2cdFAcoTaAVLxDMDjw6942Z72gu42cW6/urI8qcXv
	 Ud3WzdN9C/CeOJVxXMd1rbkZQaps22haTrHskTtOvzJttL6kwL3Z7UX6zoDVEZliFk
	 5vBgZXQJIcZrw==
Message-ID: <88ec807d16a7eb2be252eea0c10e3374c01da1bf.camel@kernel.org>
Subject: Re: [RFCv2 2/7] lockd: FILE_LOCK_DEFERRED only on FL_SLEEP
From: Jeff Layton <jlayton@kernel.org>
To: Alexander Aring <aahringo@redhat.com>, linux-nfs@vger.kernel.org
Cc: cluster-devel@redhat.com, ocfs2-devel@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, teigland@redhat.com, rpeterso@redhat.com, 
	agruenba@redhat.com, trond.myklebust@hammerspace.com, anna@kernel.org, 
	chuck.lever@oracle.com
Date: Wed, 16 Aug 2023 07:37:42 -0400
In-Reply-To: <20230814211116.3224759-3-aahringo@redhat.com>
References: <20230814211116.3224759-1-aahringo@redhat.com>
	 <20230814211116.3224759-3-aahringo@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2023-08-14 at 17:11 -0400, Alexander Aring wrote:
> This patch removes to handle non-blocking lock requests as asynchronous
> lock request returning FILE_LOCK_DEFERRED. When fl_lmops and lm_grant()
> is set and a non-blocking lock request returns FILE_LOCK_DEFERRED will
> end in an WARNING to signal the user the misusage of the API.
>=20

Probably need to rephrase the word salad in the first sentence of the
commit log. I had to go over it a few times to understand what was going
on here.

In any case, I'm guessing that the idea here is that GFS2/DLM shouldn't
ever return FILE_LOCK_DEFERRED if this is a non-wait request (i.e.
someone called F_SETLK instead of F_SETLKW)?

That may be ok, but again, lockd goes to great lengths to avoid blocking
and I think it's generally a good idea. If an upcall to DLM can take a
long time, it might be a good idea to continue to allow a !wait request
to return FILE_LOCK_DEFERRED.

I guess this really depends on the current behavior today though. Does
DLM ever return FILE_LOCK_DEFERRED on a non-blocking lock request?


> The reason why we moving to make non-blocking lock request as
> synchronized call is that we already doing this behaviour for unlock or
> cancellation as well. Those are POSIX lock operations which are handled
> in an synchronized way and waiting for an answer. For non-blocking lock
> requests the answer will probably arrive in the same time as unlock or
> cancellation operations as those are trylock operations only.
>=20
> In case of a blocking lock request we need to have it asynchronously
> because the time when the lock request getting granted is unknown.
>=20
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  fs/lockd/svclock.c | 39 +++++++--------------------------------
>  1 file changed, 7 insertions(+), 32 deletions(-)
>=20
> diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> index 7d63524bdb81..1e74a578d7de 100644
> --- a/fs/lockd/svclock.c
> +++ b/fs/lockd/svclock.c
> @@ -440,31 +440,6 @@ static void nlmsvc_freegrantargs(struct nlm_rqst *ca=
ll)
>  	locks_release_private(&call->a_args.lock.fl);
>  }
> =20
> -/*
> - * Deferred lock request handling for non-blocking lock
> - */
> -static __be32
> -nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
> -{
> -	__be32 status =3D nlm_lck_denied_nolocks;
> -
> -	block->b_flags |=3D B_QUEUED;
> -
> -	nlmsvc_insert_block(block, NLM_TIMEOUT);
> -
> -	block->b_cache_req =3D &rqstp->rq_chandle;
> -	if (rqstp->rq_chandle.defer) {
> -		block->b_deferred_req =3D
> -			rqstp->rq_chandle.defer(block->b_cache_req);
> -		if (block->b_deferred_req !=3D NULL)
> -			status =3D nlm_drop_reply;
> -	}
> -	dprintk("lockd: nlmsvc_defer_lock_rqst block %p flags %d status %d\n",
> -		block, block->b_flags, ntohl(status));
> -
> -	return status;
> -}
> -
>  /*
>   * Attempt to establish a lock, and if it can't be granted, block it
>   * if required.
> @@ -569,14 +544,14 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file=
 *file,
>  			ret =3D async_block ? nlm_lck_blocked : nlm_lck_denied;
>  			goto out_cb_mutex;
>  		case FILE_LOCK_DEFERRED:
> -			block->b_flags |=3D B_PENDING_CALLBACK;
> +			/* lock requests without waiters are handled in
> +			 * a non async way. Let assert this to inform
> +			 * the user about a API violation.
> +			 */
> +			WARN_ON_ONCE(!wait);
> =20
> -			if (wait)
> -				break;
> -			/* Filesystem lock operation is in progress
> -			   Add it to the queue waiting for callback */
> -			ret =3D nlmsvc_defer_lock_rqst(rqstp, block);
> -			goto out_cb_mutex;
> +			block->b_flags |=3D B_PENDING_CALLBACK;
> +			break;
>  		case -EDEADLK:
>  			nlmsvc_remove_block(block);
>  			ret =3D nlm_deadlock;

--=20
Jeff Layton <jlayton@kernel.org>
