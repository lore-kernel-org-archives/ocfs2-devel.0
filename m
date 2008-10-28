From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Oct 2008 12:36:52 -0700
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local
	and	global quota file handling
In-Reply-To: <12248861041077-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
Message-ID: <20081028193652.GD17578@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:08:18AM +0200, Jan Kara wrote:
> For each quota type each node has local quota file. In this file it stores
> changes users have made to disk usage via this node. Once in a while this
> information is synced to global file (and thus with other nodes) so that
> limits enforcement at least aproximately works.
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index dd17137..04bebd2 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -878,6 +878,101 @@ static inline int ocfs2_xattr_get_type(struct ocfs2_xattr_entry *xe)
>  	return xe->xe_type & OCFS2_XATTR_TYPE_MASK;
>  }
>  
> +/*
> + *  On disk structures for global quota file
> + */
> +
> +/* Magic numbers and known versions for global quota files */
> +#define OCFS2_GLOBAL_QMAGICS {\
> +	0x0cf52470, /* USRQUOTA */ \
> +	0x0cf52471  /* GRPQUOTA */ \
> +}
> +
> +#define OCFS2_GLOBAL_QVERSIONS {\
> +	0, \
> +	0, \
> +}
> +
> +/* Generic header of all quota files */
> +struct ocfs2_disk_dqheader {
> +	__le32 dqh_magic;	/* Magic number identifying file */
> +	__le32 dqh_version;	/* Quota format version */
> +};
> +
> +#define OCFS2_GLOBAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
> +
> +/* Information header of global quota file (immediately follows the generic
> + * header) */
> +struct ocfs2_global_disk_dqinfo {
> +/*00*/	__le32 dqi_bgrace;
> +	__le32 dqi_igrace;
> +	__le32 dqi_syncms;
> +	__le32 dqi_blocks;
> +/*10*/	__le32 dqi_free_blk;
> +	__le32 dqi_free_entry;
> +};

	The way I read this, the first block of a quota file contains
first the disk_dqheader, and then the local info
(global_disk_dqinfo,local_disk_dqinfo).  Is that right?  I'd love to see
the ecc field (__le64 for now) in the disk_dqheader.

> +/* Structure with global user / group information. We reserve some space
> + * for future use. */
> +struct ocfs2_global_disk_dqblk {
> +/*00*/	__le32 dqb_id;          /* ID the structure belongs to */
> +	__le32 dqb_use_count;   /* Number of nodes having reference to this structure */
> +	__le64 dqb_ihardlimit;  /* absolute limit on allocated inodes */
> +/*10*/	__le64 dqb_isoftlimit;  /* preferred inode limit */
> +	__le64 dqb_curinodes;   /* current # allocated inodes */
> +/*20*/	__le64 dqb_bhardlimit;  /* absolute limit on disk space */
> +	__le64 dqb_bsoftlimit;  /* preferred limit on disk space */
> +/*30*/	__le64 dqb_curspace;    /* current space occupied */
> +	__le64 dqb_btime;       /* time limit for excessive disk use */
> +/*40*/	__le64 dqb_itime;       /* time limit for excessive inode use */
> +	__le64 dqb_pad1;
> +/*50*/	__le64 dqb_pad2;
> +};

	We also need space for the ecc data here.  It looks like ecc
space wasn't added to this series.  Rather than comment on each
structure, just let me know when that's ready.

Joel


-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
