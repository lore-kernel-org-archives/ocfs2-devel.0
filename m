From: Wengang Wang <wen.gang.wang@ORACLE.COM>
Date: Wed, 13 Jan 2010 11:20:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100112015946.GE20285@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
Message-ID: <20100113032049.GA4045@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel and David,

I think the patch to fix the deadlock(or livelock) is not good enough
yet.
my original patch is based on that when we have requested the lock, we
don't allow to downconvert it before we release it.
but per the communications with Joel and Sunil, I found my base is
wrong. so my original patch is not good. and Joel's patch has problem
either.

On 10-01-11 17:59, Joel Becker wrote:
> [Cc'd Mark and Dave]
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 90682a0..eabe53e 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1313,6 +1313,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>  	unsigned long flags;
>  	unsigned int gen;
>  	int noqueue_attempted = 0;
> +	int lock_attempted = 0;
>  
>  	mlog_entry_void();
>  
> @@ -1347,6 +1348,25 @@ again:
>  		goto unlock;
>  	}
>  
> +	if (lock_attempted && (lockres->l_level >= level)) {
> +		/*
> +		 * We've attempted to upconvert, and the lock now has
> +		 * a level we can work with.  If we fell through to the
> +		 * next checks, we could spin in an upconvert->downconvert
> +		 * cycle as other nodes pounded us.  Instead, we jump
> +		 * out and let the caller do some work.  If a downconvert
> +		 * has come in, it will do its thing as soon as the caller
> +		 * is done.
> +		 */
> +		goto update_holders;
> +	}

before update_holders, the lock could be DCed(since no BUSY flag set by
here).

and even after update_holders, the lock could be DCed too.

so that we get ocfs2_cluster_lock()(with holders increased) returned sucessfully
but actually we don't hold the dlm lock. --thus more than one node is
considering that they have the (EX) lock.

that's could be the cause of what is happening observed by David.

regards,
wengang.
