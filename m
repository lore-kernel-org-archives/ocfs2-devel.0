From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 17 Jun 2020 11:03:48 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: load global_inode_alloc
In-Reply-To: <20200616183829.87211-3-junxiao.bi@oracle.com>
References: <20200616183829.87211-1-junxiao.bi@oracle.com>
	<20200616183829.87211-3-junxiao.bi@oracle.com>
Message-ID: <eff8f118-dfb2-62aa-22fb-a96c9997796e@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/6/17 02:38, Junxiao Bi wrote:
> set global_inode_alloc as OCFS2_FIRST_ONLINE_SYSTEM_INODE, that will make
> it load during mount. It can be used to test whether some global/system
> inodes are valid. One use case is that nfsd will test whether root inode
> is valid.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ocfs2_fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 0dd8c41bafd4..3fc99659ed09 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -326,8 +326,8 @@ struct ocfs2_system_inode_info {
>  enum {
>  	BAD_BLOCK_SYSTEM_INODE = 0,
>  	GLOBAL_INODE_ALLOC_SYSTEM_INODE,
> +#define OCFS2_FIRST_ONLINE_SYSTEM_INODE GLOBAL_INODE_ALLOC_SYSTEM_INODE
>  	SLOT_MAP_SYSTEM_INODE,
> -#define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
>  	HEARTBEAT_SYSTEM_INODE,
>  	GLOBAL_BITMAP_SYSTEM_INODE,
>  	USER_QUOTA_SYSTEM_INODE,
> 
