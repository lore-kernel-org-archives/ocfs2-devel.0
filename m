From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 06 Jan 2009 15:53:48 -0800
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] [PATCH 2/2] features: Make
 inline-data a default feature
In-Reply-To: <1230330267-1975-2-git-send-email-mfasheh@suse.com>
References: <1230330267-1975-1-git-send-email-mfasheh@suse.com>
	<1230330267-1975-2-git-send-email-mfasheh@suse.com>
Message-ID: <4963EF0C.7000700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

sob

man page will need tweaking. ;) I can handle that later.

Mark Fasheh wrote:
> Kernels since 2.6.24 have supported this, I think it's time to make it a
> default feature.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  libocfs2/feature_string.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/libocfs2/feature_string.c b/libocfs2/feature_string.c
> index 7b1f93e..e6633da 100644
> --- a/libocfs2/feature_string.c
> +++ b/libocfs2/feature_string.c
> @@ -62,7 +62,8 @@ static struct feature_level_translation ocfs2_feature_levels_table[] = {
>  
>  static ocfs2_fs_options feature_level_defaults[] = {
>  	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
> -	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC,
> +	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
> +	 OCFS2_FEATURE_INCOMPAT_INLINE_DATA,
>  	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_FEATURE_LEVEL_DEFAULT */
>  
>  	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
>   
