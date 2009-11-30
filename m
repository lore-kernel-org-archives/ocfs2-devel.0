From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 30 Nov 2009 14:57:48 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add new ioctls prototype and
 corresponding data structure to ocfs2 header.
In-Reply-To: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4B144DEC.2060504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye wrote:
> We use OCFS2_IOC_INFO to manipulate the new ioctl, the requests can
> be stored in a array of (struct ocfs2_info_request), which should be
> NULL-terminated, kernel therefore can recoginze and fill them one by
> one.
>
> The reason why we need these ioctls is to offer the none-privileged
> end-user a possibility to get filesys info gathering.
>
> Idea here is to make the spearated request small enough to guarantee
> a better backward&forward compatibility since a small piece of request
> would be less likely to be broken if filesys on raw disk get changed.
>
> Currently, the first version include following request type:
>
> 	OCFS2_INFO_CLUSTERSIZE,
> 	OCFS2_INFO_BLOCKSIZE,
> 	OCFS2_INFO_SLOTNUM,
> 	OCFS2_INFO_LABEL,
> 	OCFS2_INFO_UUID,
> 	OCFS2_INFO_FS_FEATURES
>
> It may be grown from time to time:)
>
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 69 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index e9431e4..dac7f4c 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -309,6 +309,75 @@ struct reflink_arguments {
>  };
>  #define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
>  
> +#define OCFS2_UUID_LEN              16
> +#define OCFS2_MAX_LABEL_LEN         64
>   

What's wrong with the existing OCFS2_MAX_VOL_LABEL_LEN?
For UUID, maybe define:
#define OCFS2_VOL_UUIDSTR_LEN (OCFS2_VOL_UUID_LEN * 2 + 1)

> +
> +/*
> + * Used to query fs information for none-privileged 
> + * users by using OCFS2_IOC_INFO ioctols, a series of
> + * following requests need to be NULL-terminated.
> + *
> + * Always try to separate info request into small pieces to
> + * guarantee the backward&forward compatibility.
> + */
> +struct ocfs2_info_request {
> +	__u32 ir_code;	/* Info request code */
> +	__u32 ir_flags; /* Request flags */
> +};
> +

Rename it ocfs2_info. Then you have ocfs2_info_clustersize. In the next
patch you have typedef-ed these structures presumably because the structure
name is long. Instead, shorten the name and use it as is. BTW, typedef-ing
struct is strongly discouraged in the kernel coding standards. For good 
reason.

> +struct ocfs2_info_request_clustersize {
> +	struct ocfs2_info_request ir_request;
> +	__u32 ir_clustersize;
> +};
> +
> +struct ocfs2_info_request_blocksize {
> +	struct ocfs2_info_request ir_request;
> +	__u32 ir_blocksize;
> +};
> +
> +struct ocfs2_info_request_slotnum {
> +	struct ocfs2_info_request ir_request;
> +	__u16 ir_slotnum;
> +};
> +
> +struct ocfs2_info_request_label {
> +	struct ocfs2_info_request ir_request;
> +	__u8	ir_label[OCFS2_MAX_LABEL_LEN];
> +};
> +
> +struct ocfs2_info_request_uuid {
> +	struct ocfs2_info_request ir_request;
> +	__u8	ir_uuid[OCFS2_UUID_LEN];
> +};
>   

Return the uuid string as that is what we use everywhere.

> +
> +struct ocfs2_info_request_fs_features {
> +	struct ocfs2_info_request ir_quest;
> +	__u32 ir_compat_features;
> +	__u32 ir_incompat_features;
> +	__u32 ir_ro_compat_features;
> +};
> +
> +/* Codes for cfs2_info_request */
> +
> +#define OCFS2_INFO_CLUSTERSIZE	0x00000001
> +#define OCFS2_INFO_BLOCKSIZE	0x00000002
> +#define OCFS2_INFO_SLOTNUM      0x00000004
> +#define OCFS2_INFO_LABEL        0x00000008
> +#define OCFS2_INFO_UUID         0x00000010
> +#define OCFS2_INFO_FS_FEATURES	0x00000020
>   

Fix typos, white-spaces, etc. Make use of tabs.

> +
> +/* Flags for struct ocfs2_info_request */
> +/* Filled by the caller */
> +#define OCFS2_INFO_FL_NON_COHERENT  0x00000001  /* Cluster coherency not required.
> +						   This is a hint.  It is up to
> +						   ocfs2 whether the request can
> +						   be fulfilled without locking. */
> +/* Filled by ocfs2 */
> +#define OCFS2_INFO_FL_FILLED        0x80000000  /* Filesystem understood this
> +						   request and filled in the
> +						   answer */
> +
> +#define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info_request)
>  
>  /*
>   * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
>   
