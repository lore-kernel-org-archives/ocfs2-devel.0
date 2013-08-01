From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 1 Aug 2013 00:22:50 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup dead code in
	ocfs2_acl_from_xattr()
In-Reply-To: <51F7802E.9080609@huawei.com>
References: <51F7802E.9080609@huawei.com>
Message-ID: <20130801072249.GB15266@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 30, 2013 at 04:58:22PM +0800, Joseph Qi wrote:
> In ocfs2_acl_from_xattr(), if size is less than
> sizeof(struct posix_acl_entry), it returns ERR_PTR(-EINVAL) directly.
> Then assign (size / sizeof(struct posix_acl_entry)) to count which will
> be at least 1, that means the following branch (count < 0) and
> (count == 0) will never be true.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/acl.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index 8a40457..b4f788e 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -51,10 +51,6 @@ static struct posix_acl *ocfs2_acl_from_xattr(const void *value, size_t size)
>  		return ERR_PTR(-EINVAL);
>  
>  	count = size / sizeof(struct posix_acl_entry);
> -	if (count < 0)
> -		return ERR_PTR(-EINVAL);
> -	if (count == 0)
> -		return NULL;
>  
>  	acl = posix_acl_alloc(count, GFP_NOFS);
>  	if (!acl)
> -- 
> 1.7.9.7
> 

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

			http://www.jlbec.org/
			jlbec at evilplan.org
