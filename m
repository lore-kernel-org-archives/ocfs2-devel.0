From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 18 Dec 2009 10:11:58 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-devel: remove redundant
 OCFS2_MOUNT_POSIX_ACL check in ocfs2_get_acl_nolock()
In-Reply-To: <1260857308-25404-1-git-send-email-jeff.liu@oracle.com>
References: <> <1260857308-25404-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <4B2AE4EE.7050208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Tiger Yang <tiger.yang@oracle.com>

On 12/15/2009 02:08 PM, Jeff Liu wrote:
> osb->s_mount_opt has already been checked against OCFS2_MOUNT_POSIX_ACL_CHECK before
> calling ocfs2_get_acl_nolock() in ocfs2_init_acl()&&  ocfs2_get_acl(), so remove it.
>
> Signed-off-by: Jeff Liu<jeff.liu@oracle.com>
> ---
>   fs/ocfs2/acl.c |    3 ---
>   1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index fbeaec7..42d70b7 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -104,9 +104,6 @@ static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
>   	struct posix_acl *acl;
>   	int retval;
>
> -	if (!(osb->s_mount_opt&  OCFS2_MOUNT_POSIX_ACL))
> -		return NULL;
> -
>   	switch (type) {
>   	case ACL_TYPE_ACCESS:
>   		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
