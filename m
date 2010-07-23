From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 23 Jul 2010 20:01:33 +0300
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Fix memory leak on
	mlog_sys_init error path
In-Reply-To: <1279836546-26913-6-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
	<1279836546-26913-6-git-send-email-ppannuto@codeaurora.org>
Message-ID: <4C49CAED.6020304@cs.helsinki.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, Stephen Hemminger <shemminger@vyatta.com>, Jens Axboe <jens.axboe@oracle.com>, David Teigland <teigland@redhat.com>, ocfs2-devel@oss.oracle.com

Patrick Pannuto wrote:
> This leak is the same as the bus path; mlog_kset.kobj.name is
> set, but kset_register fails, thus nothing will ever call
> kset_unregister and name will be leaked
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  fs/ocfs2/cluster/masklog.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index c7fba39..de715d4 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -154,6 +154,7 @@ static struct kset mlog_kset = {
>  int mlog_sys_init(struct kset *o2cb_kset)
>  {
>  	int i = 0;
> +	int ret;
>  
>  	while (mlog_attrs[i].attr.mode) {
>  		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
> @@ -163,7 +164,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
>  
>  	kobject_set_name(&mlog_kset.kobj, "logmask");
>  	mlog_kset.kobj.kset = o2cb_kset;
> -	return kset_register(&mlog_kset);
> +
> +	ret = kset_register(&mlog_kset);
> +	if (ret)
> +		kfree(mlog_kset.kobj.name);

Aren't we supposed to use kobject_cleanup() here?

> +	return ret;
>  }
>  
>  void mlog_sys_shutdown(void)
