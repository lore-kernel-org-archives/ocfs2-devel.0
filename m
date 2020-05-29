From: Kees Cook <keescook@chromium.org>
Date: Fri, 29 May 2020 01:14:50 -0700
Subject: [Ocfs2-devel] [PATCH 13/13] fs: move binfmt_misc sysctl to its
	own file
In-Reply-To: <20200529074108.16928-14-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-14-mcgrof@kernel.org>
Message-ID: <202005290113.53AEED2176@keescook>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, rodrigo.vivi@intel.com, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 07:41:08AM +0000, Luis Chamberlain wrote:
> This moves the binfmt_misc sysctl to its own file to help remove
> clutter from kernel/sysctl.c.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/binfmt_misc.c | 1 +
>  kernel/sysctl.c  | 7 -------
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index f69a043f562b..656b3f5f3bbf 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -821,6 +821,7 @@ static int __init init_misc_binfmt(void)
>  	int err = register_filesystem(&bm_fs_type);
>  	if (!err)
>  		insert_binfmt(&misc_format);
> +	register_sysctl_empty_subdir("fs", "binfmt_misc");
>  	return err;

Nit: let's make the dir before registering the filesystem. I can't
imagine a realistic situation where userspace is reacting so fast it
would actually fail to mount the fs on /proc/sys/fs/binfmt_misc, but why
risk it?

-Kees

>  }
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 460532cd5ac8..7714e7b476c2 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -3042,13 +3042,6 @@ static struct ctl_table fs_table[] = {
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_TWO,
>  	},
> -#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
> -	{
> -		.procname	= "binfmt_misc",
> -		.mode		= 0555,
> -		.child		= sysctl_mount_point,
> -	},
> -#endif
>  	{
>  		.procname	= "pipe-max-size",
>  		.data		= &pipe_max_size,
> -- 
> 2.26.2
> 

-- 
Kees Cook
