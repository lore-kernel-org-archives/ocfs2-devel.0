From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Sep 2016 14:20:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: free the mle while the res had one,
 to avoid mle memory leak.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <20160913142012.2e2b071e1923e8fef6182274@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 13 Sep 2016 07:52:30 +0000 Guozhonghua <guozhonghua@h3c.com> wrote:

> In the function dlm_migrate_request_handler, while the ret is --EEXIST, the mle should be freed, otherwise the memory will be leaked.
> 
> Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
> 
> --- ocfs2.orig/dlm/dlmmaster.c  2016-09-13 15:18:13.602684325 +0800
> +++ ocfs2/dlm/dlmmaster.c       2016-09-13 15:27:05.014675736 +0800
> @@ -3188,6 +3188,9 @@ int dlm_migrate_request_handler(struct o
>                                     migrate->new_master,
>                                     migrate->master);
> 
> +       if (ret < 0)
> +               kmem_cache_free(dlm_mle_cache, mle);
> +
>         spin_unlock(&dlm->master_lock);
>  unlock:
>         spin_unlock(&dlm->spinlock);

Looks OK to me.

I wonder if there's another bug here.  If dlm_add_migration_mle()
failed, is it correct to go ahead and detach `oldmle'?
