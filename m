From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Jan 2016 15:02:28 -0800
Subject: [Ocfs2-devel] [PATCH v3 1/4] ocfs2: export ocfs2_kset for
	online file check
In-Reply-To: <1451027779-6849-2-git-send-email-ghe@suse.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<1451027779-6849-2-git-send-email-ghe@suse.com>
Message-ID: <20160113230228.GJ819@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

On Fri, Dec 25, 2015 at 03:16:16PM +0800, Gang He wrote:
> Export ocfs2_kset object from ocfs2_stackglue kernel module,
> then online file check code will create the related sysfiles
> under ocfs2_kset object.
> 
> Signed-off-by: Gang He <ghe@suse.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

This was easy to review, though you might consider adding a note that we're
exporting this because it's built in ocfs2_stackglue.ko.
	--Mark


> ---
>  fs/ocfs2/stackglue.c | 3 ++-
>  fs/ocfs2/stackglue.h | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 5d965e8..13219ed 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -629,7 +629,8 @@ static struct attribute_group ocfs2_attr_group = {
>  	.attrs = ocfs2_attrs,
>  };
>  
> -static struct kset *ocfs2_kset;
> +struct kset *ocfs2_kset;
> +EXPORT_SYMBOL_GPL(ocfs2_kset);
>  
>  static void ocfs2_sysfs_exit(void)
>  {
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index 66334a3..f2dce10 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -298,4 +298,6 @@ void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_p
>  int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
>  void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
>  
> +extern struct kset *ocfs2_kset;
> +
>  #endif  /* STACKGLUE_H */
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
Mark Fasheh
