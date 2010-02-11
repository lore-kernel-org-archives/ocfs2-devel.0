From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 11 Feb 2010 12:41:25 -0800
Subject: [Ocfs2-devel] [PATCH 01/11] ocfs2_dlmfs: Add capabilities
	parameter.
In-Reply-To: <1265794074-19539-2-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
	<1265794074-19539-2-git-send-email-joel.becker@oracle.com>
Message-ID: <4B746B75.8010801@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Joel Becker wrote:
> Over time, dlmfs has added some features that were not part of the
> initial ABI.  Unfortunately, some of these features are not detectable
> via standard usage.  For example, Linux's default poll always returns
> POLLIN, so there is no way for a caller of poll(2) to know when dlmfs
> added poll support.  Instead, we provide this list of new capabilities.
>
> Capabilities is a read-only attribute.  We do it as a module parameter
> so we can discover it whether dlmfs is built in, loaded, or even not
> loaded (via modinfo).
>
> The ABI features are local to this machine's dlmfs mount.  This is
> distinct from the locking protocol, which is concerned with inter-node
> interaction.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmfs.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
> index 02bf178..77d0df4 100644
> --- a/fs/ocfs2/dlm/dlmfs.c
> +++ b/fs/ocfs2/dlm/dlmfs.c
> @@ -81,6 +81,42 @@ static const struct dlm_protocol_version user_locking_protocol = {
>  	.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
>  };
>  
> +
> +/*
> + * These are the ABI capabilities of dlmfs.
> + *
> + * Over time, dlmfs has added some features that were not part of the
> + * initial ABI.  Unfortunately, some of these features are not detectable
> + * via standard usage.  For example, Linux's default poll always returns
> + * POLLIN, so there is no way for a caller of poll(2) to know when dlmfs
> + * added poll support.  Instead, we provide this list of new capabilities.
> + *
> + * Capabilities is a read-only attribute.  We do it as a module parameter
> + * so we can discover it whether dlmfs is built in, loaded, or even not
> + * loaded.
> + *
> + * The ABI features are local to this machine's dlmfs mount.  This is
> + * distinct from the locking protocol, which is concerned with inter-node
> + * interaction.
> + */
> +#define DLMFS_CAPABILITIES ""
> +extern int param_set_dlmfs_capabilities(const char *val,
> +					struct kernel_param *kp)
> +{
> +	printk(KERN_ERR "%s: readonly parameter\n", kp->name);
> +	return -EINVAL;
> +}
> +static int param_get_dlmfs_capabilities(char *buffer,
> +					struct kernel_param *kp)
> +{
> +	return strlcpy(buffer, DLMFS_CAPABILITIES,
> +		       strlen(DLMFS_CAPABILITIES) + 1);
> +}
> +module_param_call(capabilities, param_set_dlmfs_capabilities,
> +		  param_get_dlmfs_capabilities, NULL, 0444);
> +MODULE_PARM_DESC(capabilities, DLMFS_CAPABILITIES);
> +
> +
>  /*
>   * decodes a set of open flags into a valid lock level and a set of flags.
>   * returns < 0 if we have invalid flags
>   
