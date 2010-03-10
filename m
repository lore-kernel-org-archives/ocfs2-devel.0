From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 9 Mar 2010 17:43:52 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update i_blocks in reflink
	operations.
In-Reply-To: <1268111579-8600-1-git-send-email-tao.ma@oracle.com>
References: <1268111579-8600-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100310014352.GL6914@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 09, 2010 at 01:12:59PM +0800, Tao Ma wrote:
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

	Curiously, why wouldn't it just be s_inode->i_blocks?

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
