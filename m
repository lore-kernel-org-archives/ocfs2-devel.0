From: jeff.liu <jeff.liu@oracle.com>
Date: Tue, 09 Mar 2010 17:33:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update i_blocks in reflink
	operations.
In-Reply-To: <1268111579-8600-1-git-send-email-tao.ma@oracle.com>
References: <1268111579-8600-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4B9615DD.3090500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

It works for my simple tests.

st_blks_ref is a flesh reflinked file.

jeff at jeff-laptop:/ocfs2$ ./st st_blks_ref

blocks#: 2048

It will show ZERO without this patch.

jeff at jeff-laptop:/ocfs2$ cat st.c
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int fd;
	struct stat st;

	if (!argv[1]) {
		fprintf(stderr, "Usage:%s pathname\n", argv[0]);
		return -1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return -1;
	}

	if (fstat(fd, &st) < 0) {
		perror("fstat");
		return -1;
	}

	fprintf(stderr, "blocks#: %d\n", st.st_blocks);

	return 0;
}


Thanks,
Jeff

Tao Ma wrote:
> In reflink, we need to upate i_blocks for the target inode.
> 
> Reported-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/refcounttree.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 9e96921..f4aad88 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4075,6 +4075,7 @@ static int ocfs2_complete_reflink(struct inode *s_inode,
>  	OCFS2_I(t_inode)->ip_dyn_features = OCFS2_I(s_inode)->ip_dyn_features;
>  	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
>  	i_size_write(t_inode, size);
> +	t_inode->i_blocks = ocfs2_inode_sector_count(t_inode);
>  
>  	di->i_xattr_inline_size = s_di->i_xattr_inline_size;
>  	di->i_clusters = s_di->i_clusters;
