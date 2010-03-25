From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Mar 2010 13:45:15 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: one more warning fix in
 ocfs2_file_aio_write()
In-Reply-To: <4BABC5D3.50400@suse.de>
References: <4BABC5D3.50400@suse.de>
Message-ID: <20100325204515.GB9984@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2010 at 04:21:39AM +0800, Coly Li wrote:
> This patch fixes another compiling warning in ocfs2_file_aio_write() like this,
>     fs/ocfs2/file.c: In function ?ocfs2_file_aio_write?:
>     fs/ocfs2/file.c:2026: warning: suggest parentheses around ?&&? within ?||?
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> ---
>  fs/ocfs2/file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 17947dc..c4638fd 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2021,8 +2021,8 @@ out_dio:
>  		if (ret < 0)
>  			written = ret;
> 
> -		if (!ret && (old_size != i_size_read(inode) ||
> -		    old_clusters != OCFS2_I(inode)->ip_clusters ||
> +		if ((!ret) && ((old_size != i_size_read(inode)) ||

	You don't need to wrap the !ret.  It's unary.

Joel

-- 

Life's Little Instruction Book #510

	"Count your blessings."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
