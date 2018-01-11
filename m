From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 11 Jan 2018 10:10:25 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: assign errno to 'ret' in
 ocfs2_calc_xattr_init()
References: <5A571CAF.8050709@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F290F238@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Changwei Ge <ge.changwei@h3c.com>

On 2018/1/11 16:14, piaojun wrote:
> We need catch the errno returned by ocfs2_xattr_get_nolock() and assign
> it to 'ret' for printing and noticing upper callers.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>   fs/ocfs2/xattr.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 5fdf269..439f567 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -646,6 +646,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
>   			if (S_ISDIR(mode))
>   				a_size <<= 1;
>   		} else if (acl_len != 0 && acl_len != -ENODATA) {
> +			ret = acl_len;
>   			mlog_errno(ret);
>   			return ret;
>   		}
> 
