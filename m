From: Xiaoming Ni <nixiaoming@huawei.com>
Date: Thu, 4 Jun 2020 16:45:20 +0800
Subject: [Ocfs2-devel] [PATCH 13/13] fs: move binfmt_misc sysctl to its
	own file
In-Reply-To: <20200529074108.16928-14-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-14-mcgrof@kernel.org>
Message-ID: <6cbba430-a768-72db-bd45-bcbba0376219@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>, keescook@chromium.org, yzaikin@google.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: wangle6@huawei.com, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, alex.huangjianhui@huawei.com, laiyuanyuan.lai@huawei.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

On 2020/5/29 15:41, Luis Chamberlain wrote:
> This moves the binfmt_misc sysctl to its own file to help remove
> clutter from kernel/sysctl.c.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   fs/binfmt_misc.c | 1 +
>   kernel/sysctl.c  | 7 -------
>   2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index f69a043f562b..656b3f5f3bbf 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -821,6 +821,7 @@ static int __init init_misc_binfmt(void)
>   	int err = register_filesystem(&bm_fs_type);
>   	if (!err)
>   		insert_binfmt(&misc_format);
> +	register_sysctl_empty_subdir("fs", "binfmt_misc");
>   	return err;
>   }
build error when CONFIG_BINFMT_MISC=m

ERROR: modpost: "register_sysctl_empty_subdir" [fs/binfmt_misc.ko] 
undefined!

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 27f0c9ea..4129dfb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2853,6 +2853,7 @@ void register_sysctl_empty_subdir(const char *base,
  {
         register_sysctl_subdir(base, subdir, sysctl_mount_point);
  }
+EXPORT_SYMBOL_GPL(register_sysctl_empty_subdir);
  #endif /* CONFIG_SYSCTL */


Thanks
Xiaoming Ni
