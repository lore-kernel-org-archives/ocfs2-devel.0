From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 07 Dec 2009 13:42:09 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: don't leave free'd mle
 attached to hb events
In-Reply-To: <200912071453.nB6Mhdbo021627@rgminet13.oracle.com>
References: <200912071453.nB6Mhdbo021627@rgminet13.oracle.com>
Message-ID: <4B1D76B1.1020404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK

wengang wang wrote:
> don't leave free'd mle attached to hb events.
>     
> in dlm_add_migration_mle() the mle is attched to "heartbeat events" anyway no
> matter there is an existing mle with same name(returns -EEXIST).
> dlm_migrate_lockres() calls dlm_add_migration_mle(). in case the later function
> returning -EEXIST, dlm_migrate_lockres() frees the (new) mle without detaching
> it from "hb events". so that later "hb events" related operations could improperly
> operate against wrong mle objects or against an invalid memory address.

The mle is attached to hb events in dlm_init_mle() which is not called
if it returns -EEXIST. When it returns -EEXIST, oldmle is set to the
existing mle and its refcounting is handled correctly. mle is not touched
and thus only needs to be freed.

> the patch fixes above problem. it marks the mle as "added" just after
> dlm_add_migration_mle() is called.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 83bcaf2..0df80e9 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2498,11 +2498,12 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	spin_unlock(&dlm->master_lock);
>  	spin_unlock(&dlm->spinlock);
>  
> +	mle_added = 1;
> +
>  	if (ret == -EEXIST) {
>  		mlog(0, "another process is already migrating it\n");
>  		goto fail;
>  	}
> -	mle_added = 1;
>  
>  	/*
>  	 * set the MIGRATING flag and flush asts
>   
