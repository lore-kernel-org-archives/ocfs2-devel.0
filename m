From: Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 29 May 2020 12:26:13 +0200
Subject: [Ocfs2-devel] [PATCH 09/13] firmware_loader: simplify sysctl
 declaration with register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-10-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-10-mcgrof@kernel.org>
Message-ID: <20200529102613.GA1345939@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, rodrigo.vivi@intel.com, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 07:41:04AM +0000, Luis Chamberlain wrote:
> From: Xiaoming Ni <nixiaoming@huawei.com>
> 
> Move the firmware config sysctl table to fallback_table.c and use the
> new register_sysctl_subdir() helper. This removes the clutter from
> kernel/sysctl.c.
> 
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/base/firmware_loader/fallback.c       |  4 ++++
>  drivers/base/firmware_loader/fallback.h       | 11 ++++++++++
>  drivers/base/firmware_loader/fallback_table.c | 22 +++++++++++++++++--
>  include/linux/sysctl.h                        |  1 -
>  kernel/sysctl.c                               |  7 ------
>  5 files changed, 35 insertions(+), 10 deletions(-)

So it now takes more lines than the old stuff?  :(

> 
> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
> index d9ac7296205e..8190653ae9a3 100644
> --- a/drivers/base/firmware_loader/fallback.c
> +++ b/drivers/base/firmware_loader/fallback.c
> @@ -200,12 +200,16 @@ static struct class firmware_class = {
>  
>  int register_sysfs_loader(void)
>  {
> +	int ret = register_firmware_config_sysctl();
> +	if (ret != 0)
> +		return ret;

checkpatch :(

>  	return class_register(&firmware_class);

And if that fails?

>  }
>  
>  void unregister_sysfs_loader(void)
>  {
>  	class_unregister(&firmware_class);
> +	unregister_firmware_config_sysctl();
>  }
>  
>  static ssize_t firmware_loading_show(struct device *dev,
> diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
> index 06f4577733a8..7d2cb5f6ceb8 100644
> --- a/drivers/base/firmware_loader/fallback.h
> +++ b/drivers/base/firmware_loader/fallback.h
> @@ -42,6 +42,17 @@ void fw_fallback_set_default_timeout(void);
>  
>  int register_sysfs_loader(void);
>  void unregister_sysfs_loader(void);
> +#ifdef CONFIG_SYSCTL
> +extern int register_firmware_config_sysctl(void);
> +extern void unregister_firmware_config_sysctl(void);
> +#else
> +static inline int register_firmware_config_sysctl(void)
> +{
> +	return 0;
> +}
> +static inline void unregister_firmware_config_sysctl(void) { }
> +#endif /* CONFIG_SYSCTL */
> +
>  #else /* CONFIG_FW_LOADER_USER_HELPER */
>  static inline int firmware_fallback_sysfs(struct firmware *fw, const char *name,
>  					  struct device *device,
> diff --git a/drivers/base/firmware_loader/fallback_table.c b/drivers/base/firmware_loader/fallback_table.c
> index 46a731dede6f..4234aa5ee5df 100644
> --- a/drivers/base/firmware_loader/fallback_table.c
> +++ b/drivers/base/firmware_loader/fallback_table.c
> @@ -24,7 +24,7 @@ struct firmware_fallback_config fw_fallback_config = {
>  EXPORT_SYMBOL_NS_GPL(fw_fallback_config, FIRMWARE_LOADER_PRIVATE);
>  
>  #ifdef CONFIG_SYSCTL
> -struct ctl_table firmware_config_table[] = {
> +static struct ctl_table firmware_config_table[] = {
>  	{
>  		.procname	= "force_sysfs_fallback",
>  		.data		= &fw_fallback_config.force_sysfs_fallback,
> @@ -45,4 +45,22 @@ struct ctl_table firmware_config_table[] = {
>  	},
>  	{ }
>  };
> -#endif
> +
> +static struct ctl_table_header *hdr;
> +int register_firmware_config_sysctl(void)
> +{
> +	if (hdr)
> +		return -EEXIST;

How can hdr be set?

> +	hdr = register_sysctl_subdir("kernel", "firmware_config",
> +				     firmware_config_table);
> +	if (!hdr)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void unregister_firmware_config_sysctl(void)
> +{
> +	if (hdr)
> +		unregister_sysctl_table(hdr);

Why can't unregister_sysctl_table() take a null pointer value?

And what sets 'hdr' (worst name for a static variable) to NULL so that
it knows not to be unregistered again as it looks like
register_firmware_config_sysctl() could be called multiple times.

thanks,

greg k-h
