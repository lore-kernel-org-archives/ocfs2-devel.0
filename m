From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Mar 2009 02:29:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use xs->bucket to set xattr
	value	outside.
In-Reply-To: <1236642573-4073-1-git-send-email-tao.ma@oracle.com>
References: <1236642573-4073-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090312092926.GC2014@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 10, 2009 at 07:49:33AM +0800, Tao Ma wrote:
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index f1b9af1..503a1d7 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -4795,19 +4795,34 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
>  						char *val,
>  						int value_len)
>  {
> -	int offset;
> +	int ret, offset, block_off;
>  	struct ocfs2_xattr_value_root *xv;
>  	struct ocfs2_xattr_entry *xe = xs->here;
> +	struct ocfs2_xattr_bucket *bucket = xs->bucket;
> +	struct ocfs2_xattr_header *xh = bucket_xh(bucket);

	You only use 'bucket' once, to initialize xh.  I'd rather you
remove that variable and initialize xh with 'bucket_xh(xs->bucket)'.  It
saves us some stack space.

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
