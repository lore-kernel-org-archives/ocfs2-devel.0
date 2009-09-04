From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 4 Sep 2009 16:11:42 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlog_errno to aops.c
In-Reply-To: <200909040249.n842n0W7027642@acsinet15.oracle.com>
References: <200909040249.n842n0W7027642@acsinet15.oracle.com>
Message-ID: <20090904231142.GC945@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 04, 2009 at 10:48:38AM +0800, Wengang Wang wrote:
>   when an error is hit, printing the error number is helpful.
> this patch adds prints in such cases in aops.c.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/aops.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index b2c52b3..04e0760 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -349,8 +349,10 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
>  	 * lock inversion, but don't bother with retrying.
>  	 */
>  	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
> -	if (ret)
> +	if (ret) {
> +		mlog_errno(ret);
>  		return err;
> +	}

	Make sure that you don't print EAGAIN.

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
