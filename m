From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 17:29:26 -0800
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: Introduce dir free space list
In-Reply-To: <1233351753-14640-5-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-5-git-send-email-mfasheh@suse.com>
Message-ID: <20090131012926.GD6155@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:30PM -0800, Mark Fasheh wrote:
> The only operation which doesn't get faster with directory indexing is
> insert, which still has to walk the entire unindexed directory portion to
> find a free block. This patch provides an improvement in directory insert
> performance by maintaining a singly linked list of directory leaf blocks
> which have space for additional dirents.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Two small comments inline.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> @@ -2074,8 +2280,12 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
>  	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
>  
>  	de = ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data, size);
> -	if (ocfs2_supports_dir_trailer(osb))
> -		ocfs2_init_dir_trailer(inode, new_bh);
> +	if (ocfs2_new_dir_wants_trailer(inode)) {
> +		int size = le16_to_cpu(de->rec_len);
> +		size -= OCFS2_DIR_REC_LEN(2);
> +		size -= sizeof(struct ocfs2_dir_block_trailer);
> +		ocfs2_init_dir_trailer(inode, new_bh, size);
> +	}

I don't get why you are...oh, I get it.  In fill_new_dir_el(), you're
starting with the rec_len of '..', then subtracting the "real" portion
of that dirent.  That describes the hole.  Can we get a comment - it
wasn't obvious.

> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 09ab57e..5d45bcf 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -416,6 +416,7 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
>  #define OCFS2_DIR_REC_LEN(name_len)	(((name_len) + OCFS2_DIR_MEMBER_LEN + \
>                                            OCFS2_DIR_ROUND) & \
>  					 ~OCFS2_DIR_ROUND)
> +#define OCFS2_DIR_MIN_REC_LEN	OCFS2_DIR_REC_LEN(1)

	I think tools has this defined in ocfs2.h or dirblock.h or
something.  So when you bring ocfs2_fs.h over to tools, make sure to
remove any tools copy of this macro.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
