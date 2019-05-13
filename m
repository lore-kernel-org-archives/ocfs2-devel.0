From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 13 May 2019 15:28:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix error path kobject memory leak
In-Reply-To: <20190513033458.2824-1-tobin@kernel.org>
References: <20190513033458.2824-1-tobin@kernel.org>
Message-ID: <a4c16c11-15f4-cc34-9c31-69c7ce900486@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tobin C. Harding" <tobin@kernel.org>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>



On 19/5/13 11:34, Tobin C. Harding wrote:
> If a call to kobject_init_and_add() fails we should call kobject_put()
> otherwise we leak memory.
> 
> Add call to kobject_put() in the error path of call to
> kobject_init_and_add().  Please note, this has the side effect that
> the release method is called if kobject_init_and_add() fails.
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> 
> Is it ok to send patches during the merge window?
> 
> Applies on top of Linus' mainline tag: v5.1
> 
> Happy to rebase if there are conflicts.
> 
> thanks,
> Tobin.
> 
>  fs/ocfs2/filecheck.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index f65f2b2f594d..1906cc962c4d 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -193,6 +193,7 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
>  					NULL, "filecheck");
>  	if (ret) {
> +		kobject_put(&entry->fs_kobj);
>  		kfree(fcheck);
>  		return ret;
>  	}
> 
