Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE11550DCE
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991139; cv=none; b=BCGJ3qgR9RoTTPugBsV3NjEZ7FCN4bJTcrpjYnxIRgC5LQAz6jLI1T+FtEmvutZYFFs+YK5+PN8FE7zI21BZ37yDvwpzvW47KtVmgu7rtGVWLPVNYQLeYBNEAktXkJgrGZOWXhsq5weM5xPOxDGSaUFafby/59lXa1DeXQvv4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991139; c=relaxed/simple;
	bh=Iqv7An2ELPabpUT7OVtm+I8Wass6AmEfu1El7+uJI7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XsViVCNt6yn6nOfTrNCER4KZU084bwQ74zEYaD9S+X2VrIf1qLOddwMZHLnUUfFng+rQWdqfb288qzPOEj+CI7lsHXAub0kdA/YiRlU9Mr/dNvdxbw3m3PIBIbXVsPeI4wLIaenPB1xRRvEhPTPtqVjmgqCJRhNnoamfl5+wQ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cC7fohK1; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cC7fohK1"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c347be93d54so50246466b.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 08:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791991135; x=1792595935; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eap6P8yfIrxQOWUklCvJ8ok9fbtwgYdF5plY1PGn76k=;
        b=cC7fohK1DTca4zKiQ8XGjE3J2M1kNRukFnKPlFuqL4FL0ridb1JMdJ6EYHNI1iUt1g
         ODhMoq3FOJroCY+cHeQkx/NBhGnBM10T0EH37rYNQnKLqX+tqbbb63HBjiVU4S1q6ciL
         CFig6+70VvN9erf/nu9xxSzg29ggJFYpfkM1jXtr3ZCUIi4hqqReaBXNWJeiKL1w5Ijd
         /pcemQLRlkX83q6XvZU6zJfzXTGKcuzCJHbXjyGYSkdftB17GjqCJsR7DFHS8NdsYqJs
         1sOaHHa75+a164xLz1+J2k9nT84bsrjSu+8az3gQrwQyFyU+dPgVQ27cjuXZvQjlazHO
         NlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991135; x=1792595935;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eap6P8yfIrxQOWUklCvJ8ok9fbtwgYdF5plY1PGn76k=;
        b=zjBKLmsE6J64ySOtCi+FTiGgeZCUpHZDJ0jMGc+cMU7ek3xY1k0rVyR4YJtdbcJ+ZT
         TkLTgtCG3i6bDaW/MHCLqeeEYIIFNxjNwEUEBL1f//mfJ/3SMdxpBP85AR84o49434Uh
         u8x8QVLasswF7j8v0uawNDNVnf+EL8kOp/qgd17FE0DHbF3KIlGkBsXm1KSM41vhFLLx
         GIWuD25MEnIg1Kxp+6dUgUzw07RE9pJkEZ2LvnH4bE5mIksvk25GgcZFS4M2lExMvXSC
         q4GSwoRlYJxtKl10G/s5cgYmoWchE/T7Rvsh9FWLpFr/8LQhuoMgQadzEXuTRCcF26Ga
         2KPw==
X-Forwarded-Encrypted: i=1; AKwUvBzFpOeA4Rw3b/dfvgF77tn1x6fK9VULKM18OmitmBYZBIsvwIgzVdSo71g81aOTQdxhMmtiZXvdYr2HDg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJf30evcxM7wU+JN9zPPXV++dymzLmN+VHIB0MaGa+I/tTF1ICe
	j0PoOVtKgVNyE8wrheDqpyADdYkwg/G1FK9K6Gm8mjMuvzsG8a07Qm3YIr7TFPyydsMCWfHg8wj
	2mBVyFMM=
X-Gm-Gg: AYBFou3rFNrcgSaNgNSAspjsuDMy3d1mnab2a0VxMeF2xUhAe6kOWUZtqO/E/3994d7
	vEY4RTcxQ+bCrxurhmEgOgI/9VjjD0YpWMpxivQ5JADN/UWa2C9eiEDr1NB3YXWEpWyWKXPX/yn
	dw+W0hI6idCf/OCFgaTe5rpKUX/hcx3AZLEUgzyPLeREQwRmScaFebswFdCf5IJQ5Z4wUpvXVn3
	VYdBGAAoS5uWinovuflzlElkWw32xrBxN+C4o9ZlkdckNLN5J+ssE3PtvkdutbzixmD+sDn0FzB
	tpGszdNWpQP5eEdkwHoG012gbZBUzcu3kRQZQi+Fx4aa21wEudDds1svbkjN2Z0vsZbHgxQ1YED
	uE6U0vz3BdmTm8BnQDdzm0aD0tZ0wU5uxRZh2PuAntwjp3aQ3nIigHTPqtFUyhxzvGgrgUBm38Q
	nr8zJjmOSiWrKgc6OxI5WsKwTvIFcgaIQgENoxAwgkkMknnOdAUmhHCKZzOshs3pFgp7HZUjAmH
	sLKkmo=
X-Received: by 2002:a17:907:7fab:b0:c29:5637:ed76 with SMTP id a640c23a62f3a-c31a9d117ebmr1775364166b.2.1791991134891;
        Wed, 14 Oct 2026 08:18:54 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd61fc465c3sm1990361a12.27.2026.10.14.08.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:18:53 -0700 (PDT)
Date: Wed, 14 Oct 2026 23:18:50 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/dlm: hold the lookup reference across convert AST
 enqueue
Message-ID: <as-cs6Pxot8LavVG@p15>
References: <20261014112321.2955584-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014112321.2955584-1-joseph.qi@linux.alibaba.com>

On Wed, Oct 14, 2026 at 07:23:21PM +0800, Joseph Qi wrote:
> dlm_convert_lock_handler() drops the reference it took when it found the
> lock on res->granted at its leave label, one statement before it calls
> dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
> list and base references, so a peer death landing in that gap leaves the
> handler's own put as the one that frees the lock, and __dlm_queue_ast()
> then reads lock->lockres from freed memory.
> 
> The handler is registered next to dlm_create_lock_handler(), so a convert
> message buffered on a dying peer's socket arrives on the same o2net
> receive work that o2net_disconnect_node() does not wait for.  The two can
> interleave as follows, with the reference counts as they are before this
> fix:
> 
>   Socket data-ready       Node-down thread      Receive worker
>   -----------------       ----------------      --------------
>   o2net_data_ready()
>     select sc under
>     callback read lock
>                           o2net_disconnect_node()
>                             queue shutdown
>                             begin flush; new color
>     queue sc_rx_work
>     in the new color
>     release callback lock
>                             shutdown socket
>                             flush returns
>                                                 read buffered convert_lock
>                                                 dlm_convert_lock_handler()
>                                                   find lock on res->granted
>                                                   dlm_lock_get()  refs = 3
>                                                   lock res->spinlock
>                                                   __dlmconvert_master()
>                                                     call_ast = 1
>                                                   unlock res->spinlock
>                           DLM node-down cleanup
>                             lock res->spinlock
>                             dlm_free_dead_locks()
>                               unlink lock
>                               put list ref  refs = 2
>                               put base ref  refs = 1
>                             unlock res->spinlock
>                                                 dlm_lock_put()  refs = 0
>                                                   free lock
>                                                 dlm_queue_ast()
>                                                   __dlm_queue_ast()
>                                                   read lock->lockres
>                                                   (use-after-free)
> 
> __dlmconvert_master() only moves the lock between lists, so the count
> entering the gap is base, list and lookup.  Drop the lookup reference
> after the AST is queued instead of before it and the race ends with the
> one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
> ast_pending cleared and ast_list unlinked.  No extra get is needed, and
> the normal case ends with the same count as before.
> 
> dlmconvert_master() has the same shape but is only reached from dlmlock()
> for a lock this node owns, which dlm_free_dead_locks() never matches.
> 
> Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

The code looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

btw, how do you find the issue?

> ---
>  fs/ocfs2/dlm/dlmconvert.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index 450d46eefab32..8a828448ba958 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -534,15 +534,19 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  leave:
> -	if (lock)
> -		dlm_lock_put(lock);
> -
>  	/* either queue the ast or release it, if reserved */
>  	if (call_ast)
>  		dlm_queue_ast(dlm, lock);
>  	else if (ast_reserved)
>  		dlm_lockres_release_ast(dlm, res);
>  
> +	/*
> +	 * Keep the lock alive through AST enqueue: a concurrent
> +	 * dlm_free_dead_locks() drops the list and base references.
> +	 */
> +	if (lock)
> +		dlm_lock_put(lock);
> +
>  	if (kick_thread)
>  		dlm_kick_thread(dlm, res);
>  
> -- 
> 2.39.3
> 
