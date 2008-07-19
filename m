From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 18 Jul 2008 17:44:37 -0700
Subject: [Ocfs2-devel] [PATCH 05/15] Add xattr header in ocfs2.v2
In-Reply-To: <20080627070110.GA20347@tma-pc2.cn.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070110.GA20347@tma-pc2.cn.oracle.com>
Message-ID: <20080719004437.GE659@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:01:10PM +0800, Tao Ma wrote:
> Modification from V1 to V2:
> Add EA disk layout to ocfs2_fs.h.

<snip>

> +struct ocfs2_xattr_block {
> +/*00*/	__u8	xb_signature[8];
> +	__le16	xb_suballoc_slot;
> +	__le16	xb_suballoc_bit;
> +	__le32	xb_fs_generation;
> +/*10*/	__le32	xb_csum;
> +	__le16	xb_flags;
> +	__le16	xb_reserved0;
> +	__le64	xb_blkno;
> +/*20*/	__le64	xb_reserved1[2];
> +/*30*/	union {
> +		struct ocfs2_xattr_header	xb_header;
> +		struct ocfs2_xattr_tree_root	xb_root;
> +	} xb_attrs;
> +};

Hey Tao,
	Can you grow xb_csum to a __le64?  The actual struct
ocfs2_block_check takes 64bits, so I want to reserve it up front.  Maybe
shift xb_blkno above it, then xb_csum, then the flags and resererveds?

Joel

-- 

"Not being known doesn't stop the truth from being true."
        - Richard Bach

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
