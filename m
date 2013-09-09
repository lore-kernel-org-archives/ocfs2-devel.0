From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 9 Sep 2013 14:42:20 -0700
Subject: [Ocfs2-devel] [PATCH 2/6] Add clustername while creating new
	lockspace
In-Reply-To: <20130906032732.GA4159@shrek.lan>
References: <20130906032732.GA4159@shrek.lan>
Message-ID: <20130909214220.GD31381@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 05, 2013 at 10:27:37PM -0500, Goldwyn Rodrigues wrote:
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 01b8516..60f3d8e 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2239,6 +2239,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  			status = -EINVAL;
>  			goto bail;
>  		}
> +		memcpy(osb->osb_cluster_name,
> +			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
> +			OCFS2_CLUSTER_NAME_LEN);

In the case of no extended cluster info (think o2cb stack) this field would
be NULL. Have you tested with o2cb to see what happens?

Btwm, since o2cb wouldn't ever use that info you could always put a dummy
value there if need be.
	--Mark

--
Mark Fasheh
