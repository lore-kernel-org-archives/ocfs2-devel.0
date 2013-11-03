From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 14:09:37 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] Add clustername to cluster connection
In-Reply-To: <20131018144507.GA4574@shrek.lan>
References: <20131018144507.GA4574@shrek.lan>
Message-ID: <20131103220937.GG29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 18, 2013 at 09:45:12AM -0500, Goldwyn Rodrigues wrote:
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 121da2d..c30ad6b 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2225,9 +2225,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	if (ocfs2_clusterinfo_valid(osb)) {
>  		osb->osb_stackflags =
>  			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
> -		memcpy(osb->osb_cluster_stack,
> +		strlcpy(osb->osb_cluster_stack,
>  		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
> -		       OCFS2_STACK_LABEL_LEN);
> +		       OCFS2_STACK_LABEL_LEN + 1);
>  		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';

I don't think we want to NULL terminate like this any more, right?

Otherwise the rest of this looks reasonable to me.
	--Mark

--
Mark Fasheh
