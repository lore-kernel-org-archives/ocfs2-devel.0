From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:01:21 -0800
Subject: [Ocfs2-devel] [PATCH 02/17] quota: Wire up ->quota_{enable,
 disable} callbacks into Q_QUOTA{ON, OFF}
In-Reply-To: <1421412471-4747-3-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-3-git-send-email-jack@suse.cz>
Message-ID: <20150119090121.GB27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:36PM +0100, Jan Kara wrote:
> Make Q_QUOTAON / Q_QUOTAOFF quotactl call ->quota_enable /
> ->quota_disable callback when provided. To match current behavior of
> ocfs2 & ext4 we make these quotactls turn on / off quota enforcement for
> appropriate quota type.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota/quota.c         | 31 +++++++++++++++++++++++++++----
>  include/linux/quotaops.h |  2 ++
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 5b307e2b5719..748716ffee48 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -66,18 +66,43 @@ static int quota_sync_all(int type)
>  	return ret;
>  }
>  
> +unsigned int qtype_limit_flag(int type)
> +{
> +	switch (type) {
> +	case USRQUOTA:
> +		return FS_QUOTA_UDQ_ENFD;
> +	case GRPQUOTA:
> +		return FS_QUOTA_GDQ_ENFD;
> +	case PRJQUOTA:
> +		return FS_QUOTA_PDQ_ENFD;
> +	}
> +	return 0;


What's the limit_ in the name supposed to mean?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
