From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 25 Jul 2008 02:33:15 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2-tools: Add extended
	attribute	support in mkfs.ocfs2
In-Reply-To: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080725093315.GF6317@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 25, 2008 at 03:06:38PM +0800, Tiger Yang wrote:
> diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
> index 0cfef2a..ade9ec1 100644
> --- a/include/ocfs2-kernel/ocfs2_fs.h
> +++ b/include/ocfs2-kernel/ocfs2_fs.h

	You've got an ancient version of the xattr ocfs2_fs.h here.

> +struct ocfs2_xattr_entry {
> +	__le32	xe_name_hash;
> +	__le16	xe_name_offset;
> +	__u8	xe_name_len;
> +	__u8	xe_type : 7;
> +	__u8	xe_local : 1;
> +	__le64	xe_value_size;
> +};

	We removed the bitfields.

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

	This got shuffled around for a 64bit checksum field.  Etc.  Can
you sync up with Tao?

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
