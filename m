From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 27 Feb 2009 18:22:36 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V5)
In-Reply-To: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
References: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
Message-ID: <20090228022236.GK10695@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 27, 2009 at 08:33:28PM +0800, wengang wang wrote:
> changes from v4:
> 1, let suballoc lock covers the checking of the group.
> 
> 2, add/correct some log messages.
> 
> 3, use ocfs2_read_group_descriptor() instead of diry reading the group.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Almost there!

> +	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
> +	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
> +					     &group_bh);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "read group %llu failed %d\n", bg_blkno, status);
> +		goto bail;
> +	}
> +
> +	status = ocfs2_check_group_descriptor(osb->sb, alloc_fe, group_bh);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "check group %llu faild %d\n", bg_blkno, status);
> +		goto bail;
> +	}

	The call to ocfs2_read_group_descriptor() already does the same
checkin as ocfs2_check_group_descriptor(), so you don't need to call
ocfs2_check_group_descriptor().  
	Other than that, I think this patch is done!  Do you have a test
to test it?

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
