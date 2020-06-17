From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 17 Jun 2020 11:26:46 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: fix value of OCFS2_INVALID_SLOT
In-Reply-To: <20200616183829.87211-5-junxiao.bi@oracle.com>
References: <20200616183829.87211-1-junxiao.bi@oracle.com>
	<20200616183829.87211-5-junxiao.bi@oracle.com>
Message-ID: <c10f320c-fe6e-95e0-0157-16c137c35e3b@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/6/17 02:38, Junxiao Bi wrote:
> From ocfs2 disk layout, slot number is 16 bits, but in ocfs2 implemtation,
> slot number is 32 bits, usually this will not cause any issue, because
> slot number is converting from u16 to u32, but OCFS2_INVALID_SLOT was
> defined as -1, when an invalid slot number from disk was got, it value
> was (u16)-1, and it was converted to u32, then the following checking
> in get_local_system_inode will be always skipped.
> 
>  static struct inode **get_local_system_inode(struct ocfs2_super *osb,
>                                                int type,
>                                                u32 slot)
>  {
>  	BUG_ON(slot == OCFS2_INVALID_SLOT);
> 	...
>  }
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ocfs2_fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 3fc99659ed09..19137c6d087b 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -290,7 +290,7 @@
>  #define OCFS2_MAX_SLOTS			255
>  
>  /* Slot map indicator for an empty slot */
> -#define OCFS2_INVALID_SLOT		-1
> +#define OCFS2_INVALID_SLOT		((u16)-1)
>  
>  #define OCFS2_VOL_UUID_LEN		16
>  #define OCFS2_MAX_VOL_LABEL_LEN		64
> 
