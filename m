From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 17:36:02 -0800
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: Increase max links count
In-Reply-To: <1233351753-14640-6-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-6-git-send-email-mfasheh@suse.com>
Message-ID: <20090131013602.GE6155@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:31PM -0800, Mark Fasheh wrote:
> Since we've now got a directory format capable of handling a large number of
> entries, we can increase the maximum link count supported. This only gets
> increased if the directory indexing feature is turned on.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

	Couple comments - I think one needs fixing.

> @@ -1292,7 +1293,7 @@ static int ocfs2_rename(struct inode *old_dir,
>  		}
>  
>  		if (S_ISDIR(new_inode->i_mode) ||
> -		    (newfe->i_links_count == cpu_to_le16(1))){
> +		    (ocfs2_read_links_count(newfe) == cpu_to_le16(1))) {
>  			status = ocfs2_orphan_add(osb, handle, new_inode,
>  						  newfe, orphan_name,
>  						  &orphan_insert, orphan_dir);

	ocfs2_read_links_count() returns cpu-endian numbers.  So I think
this needs to compare with "1", not "cpu_to_le16(1)".

> +static inline unsigned int ocfs2_read_links_count(struct ocfs2_dinode *di)
> +{
> +	u32 nlink = le16_to_cpu(di->i_links_count);
> +	u32 hi = le16_to_cpu(di->i_links_count_hi);
> +
> +	nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
> +
> +	return nlink;
> +}

	I *think* we can rely on links_count_hi being 0 on all
existing filesystems.  But wouldn't it be safer to just skip
links_count_hi if !FEATURE_DX?

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
