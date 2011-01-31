From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 31 Jan 2011 14:15:47 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using macro to set/clear
	*FILLED* flags in info handler.
In-Reply-To: <1296368761-23043-2-git-send-email-tristan.ye@oracle.com>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>
	<1296368761-23043-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110131221547.GH23899@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jan 30, 2011 at 02:25:59PM +0800, Tristan Ye wrote:
> It's a best-effort attempt to simplize duplicated codes here.

Nice cleanup. I have only one issue with it:


> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/ioctl.c |   38 ++++++++++++++++++++++++++++++--------
>  1 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 7a48681..731cf46 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -46,6 +46,22 @@ static inline void __o2info_set_request_error(struct ocfs2_info_request *kreq,
>  #define o2info_set_request_error(a, b) \
>  		__o2info_set_request_error((struct ocfs2_info_request *)&(a), b)
>  
> +static inline void __o2info_set_request_filled(struct ocfs2_info_request *req)
> +{
> +	req->ir_flags |= OCFS2_INFO_FL_FILLED;
> +}
> +
> +#define o2info_set_request_filled(a) \
> +		__o2info_set_request_filled((struct ocfs2_info_request *)&(a))

The macro here (and below) casts it's argument, thus defeating any
typechecking we would have gotten from the function call. Can you
pleaseremove the macro, rename the functions (take out the __) and use them
directly? I know we might then want to deref the i*_req field in the
handlers below but I don't think that's a big deal for what we gain.
	--Mark


--
Mark Fasheh
