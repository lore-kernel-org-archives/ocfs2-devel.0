From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep 20 12:05:24 2007
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Vote message and response
	structures packed
In-Reply-To: <11903111882211-git-send-email-sunil.mushran@oracle.com>
References: <11903111883960-git-send-email-sunil.mushran@oracle.com>
	<11903111882211-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20070920190520.GD21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks, applied.
	--Mark

On Thu, Sep 20, 2007 at 10:59:48AM -0700, Sunil Mushran wrote:
> The ocfs2_vote_msg and ocfs2_response_msg structs needed to be
> packed to ensure similar sizeofs in 32-bit and 64-bit arches.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/vote.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/vote.c b/fs/ocfs2/vote.c
> index 66a13ee..c053585 100644
> --- a/fs/ocfs2/vote.c
> +++ b/fs/ocfs2/vote.c
> @@ -66,7 +66,7 @@ struct ocfs2_vote_msg
>  {
>  	struct ocfs2_msg_hdr v_hdr;
>  	__be32 v_reserved1;
> -};
> +} __attribute__ ((packed));
>  
>  /* Responses are given these values to maintain backwards
>   * compatibility with older ocfs2 versions */
> @@ -78,7 +78,7 @@ struct ocfs2_response_msg
>  {
>  	struct ocfs2_msg_hdr r_hdr;
>  	__be32 r_response;
> -};
> +} __attribute__ ((packed));
>  
>  struct ocfs2_vote_work {
>  	struct list_head   w_list;
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
