From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 29 Aug 2013 17:52:33 +0800
Subject: [Ocfs2-devel] [PATCH] Use bigger nodestr to accomodate 32-bit
 node numbers
In-Reply-To: <20130828041547.GA4404@shrek.cartoons>
References: <20130828041547.GA4404@shrek.cartoons>
Message-ID: <521F19E1.8010600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,

On 08/28/2013 12:15 PM, Goldwyn Rodrigues wrote:

> While using pacemaker/corosync, the node numbers are generated using
> IP address as opposed to serial node number generation. This may
> not fit in a 8-byte string. Use a bigger string to print the 
> complete node number.

I have no experience of pacemaker/corosync, so here is my comments
pointing against this change only if we would expand the nodestr. :)

> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> --- 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 854d809..bc947e0 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1022,7 +1022,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	struct inode *inode = NULL;
>  	struct ocfs2_super *osb = NULL;
>  	struct buffer_head *bh = NULL;
> -	char nodestr[8];
> +	char nodestr[12];

We have the corresponding debugging logic at ocfs2_dismount_volume(), which
defines the nodestr with the old size, it seems that this change would cause
potential buffer overflow while restore a bigger nodestr at it.

Also, there might has another relationship to ocfs2_control_message_setn/down
at stack_user.c because we limit the length of nodenum with a marco:
#define OCFS2_CONTROL_MESSAGE_NODENUM_LEN       8

Maybe we should unify them?

Thanks,
-Jeff
