From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 28 Jul 2009 16:11:01 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] Quota support for mkfs.ocfs2
In-Reply-To: <1248717216-26617-7-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-7-git-send-email-jack@suse.cz>
Message-ID: <4A6EB295.6080203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mkfs.ocfs2/mkfs.c          |  146 +++++++++++++++++++++++++++++++++++++++++++-
>  mkfs.ocfs2/mkfs.h          |    1 +
>  mkfs.ocfs2/mkfs.ocfs2.8.in |   16 +++++
>  3 files changed, 162 insertions(+), 1 deletions(-)
> 
> diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
> index 6acc6e6..8496d03 100644
> --- a/mkfs.ocfs2/mkfs.c
> +++ b/mkfs.ocfs2/mkfs.c
> +static void format_quota_files(State *s, ocfs2_filesys *fs)
> +{
> +	errcode_t ret;
> +	ocfs2_quota_hash *usr_hash = NULL, *grp_hash = NULL;
> +
> +	/* Write correct data into quota files */
> +	if (!feature_skip(s, USER_QUOTA_SYSTEM_INODE)) {
> +		ret = ocfs2_init_fs_quota_info(fs, USRQUOTA);
> +		if (ret) {
> +			com_err(s->progname, ret,
> +				"while looking up global user quota file");
> +			goto error;
> +		}
> +		fs->qinfo[USRQUOTA].flags = 0;
> +		fs->qinfo[USRQUOTA].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
> +		fs->qinfo[USRQUOTA].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
> +		fs->qinfo[USRQUOTA].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
> +
> +		ret = ocfs2_new_quota_hash(&usr_hash);
> +		if (ret) {
> +			com_err(s->progname, ret,
> +				"while creating user quota hash.");
> +			goto error;
> +		}
> +		ret = ocfs2_init_global_quota_file(fs, USRQUOTA);
> +		if (ret) {
> +			com_err(s->progname, ret, "while creating global user "
> +				"quota file");
> +			goto error;
> +		}
> +		ret = ocfs2_init_local_quota_files(fs, USRQUOTA);
> +		if (ret) {
> +			com_err(s->progname, ret,
> +				"while initializing local user quota files");
> +			goto error;
> +		}
> +	}
> +	if (!feature_skip(s, GROUP_QUOTA_SYSTEM_INODE)) {
> +		ret = ocfs2_init_fs_quota_info(fs, GRPQUOTA);
> +		if (ret) {
> +			com_err(s->progname, ret,
> +				"while looking up global group quota file");
> +			goto error;
> +		}
> +		fs->qinfo[GRPQUOTA].flags = 0;
> +		fs->qinfo[GRPQUOTA].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
> +		fs->qinfo[GRPQUOTA].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
> +		fs->qinfo[GRPQUOTA].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
> +		ret = ocfs2_new_quota_hash(&usr_hash);
grp_hash here?

Regards,
Tao
