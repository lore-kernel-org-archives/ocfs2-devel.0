From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 15 Jan 2009 11:25:47 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return f_fsid info in
	ocfs2_statfs()
In-Reply-To: <496F8957.3000201@suse.de>
References: <496F8957.3000201@suse.de>
Message-ID: <496F8DBB.7080706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wondering whether this id needs to be endian consistent.
For failover nfs setups maybe.

Coly Li wrote:
> Currently f_fsid of struct kstatfs returned from ocfs2_statfs() is undefined (at least it should be
> filled with 0). Since in some conditions, f_fsid value might be used as (f_fsid, ino) pare to
> uniquely identify a file, ocfs2 should return a defined unique f_fsid value from ocfs2_statfs().
>
> This patch uses uuid_hash as a unique ID to initiate f_fsid value, the 32bits width is enough for
> ocfs2 membership so far.
>
> Signed-off-by: Coly Li <coly.li@suse.de>
> ---
>  fs/ocfs2/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 43ed113..fdab98a 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1425,6 +1425,8 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_bavail = buf->f_bfree;
>  	buf->f_files = numbits;
>  	buf->f_ffree = freebits;
> +	buf->f_fsid.val[0] = osb->uuid_hash & 0xFFFFFFFFUL;
> +	buf->f_fsid.val[1] = 0;
>
>  	brelse(bh);
>
>   
