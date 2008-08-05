From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 Aug 2008 13:29:48 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster/netdebug.c: fix warning
In-Reply-To: <20080805201036.GC17320@orion>
References: <20080805201036.GC17320@orion>
Message-ID: <20080805202948.GL22600@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:10:36AM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> ocfs2/cluster/netdebug.c: fix warning
> 
> fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
> 	type 'long unsigned int', but argument 17 has type 'suseconds_t'
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  fs/ocfs2/cluster/netdebug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> index d8bfa0e..cdc0ed2 100644
> --- a/fs/ocfs2/cluster/netdebug.c
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -151,7 +151,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
>  			   nst->st_send_time.tv_sec,
>  			   (unsigned long)nst->st_send_time.tv_usec,
>  			   nst->st_status_time.tv_sec,
> -			   nst->st_status_time.tv_usec);
> +			   (unsigned long)nst->st_status_time.tv_usec);

	suseconds_t is a signed long.  Can you change the format to %ld
and cast to long?  Unfortunately, we need the cast, as sparc64 and
parisc treat it as int.

Joel


-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
