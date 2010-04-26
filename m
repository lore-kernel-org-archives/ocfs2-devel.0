From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 26 Apr 2010 14:49:12 -0700
Subject: [Ocfs2-devel] [PATCH 14/17] ocfs2: Add ocfs2_gd_is_discontig.
In-Reply-To: <1271918431-8135-14-git-send-email-tao.ma@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
	<1271918431-8135-14-git-send-email-tao.ma@oracle.com>
Message-ID: <20100426214911.GI17377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 02:40:28PM +0800, Tao Ma wrote:
> Add ocfs2_gd_is_discontig so that we can test whether
> a group descriptor is discontiguous or not.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 67bb8a7..b5b3cb7 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -1574,5 +1574,11 @@ static inline void ocfs2_set_de_type(struct ocfs2_dir_entry *de,
>  	de->file_type = ocfs2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
>  }
>  
> +static inline int ocfs2_gd_is_discontig(struct ocfs2_group_desc *gd)
> +{
> +	return ((offsetof(struct ocfs2_group_desc, bg_bitmap) + gd->bg_size ==
> +		offsetof(struct ocfs2_group_desc, bg_list)) &&
> +		gd->bg_list.l_next_free_rec);

	You're missing a paren around the addition:

	return (((offsetof(struct ocfs2_group_desc, bg_bitmap) + gd->bg_size) ==
		 offsetof(struct ocfs2_group_desc, bg_list)) &&
		gd->bg_list.l_next_free_rec);
	
	Would this be more readable:

	if ((offsetof(struct ocfs2_group_desc, bg_bitmap) + gd->bg_size) !=
	    offsetof(struct ocfs2_group_desc, bg_list))
		return 0;
	/*
	 * Only valid to check l_next_free_rec if 
	 * bg_bitmap + bg_size == bg_list
	 */
	if (!gd->bg_list.l_next_free_rec)
		return 0;
	return 1;

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
