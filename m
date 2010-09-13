From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 12 Sep 2010 23:29:08 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use cpu_to_le16 for
 e_leaf_clusters in ocfs2_bg_discontig_add_extent.
In-Reply-To: <1284358193-3222-1-git-send-email-tao.ma@oracle.com>
References: <1284358193-3222-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100913062907.GA16449@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 13, 2010 at 02:09:53PM +0800, Tao Ma wrote:
> e_leaf_clusters is a le16, so use cpu_to_le16 instead
> of cpu_to_le32.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	You're right that we need to swap as an le16.

> @@ -348,7 +348,7 @@ static void ocfs2_bg_discontig_add_extent(struct ocfs2_super *osb,
>  	rec->e_blkno = cpu_to_le64(p_blkno);
>  	rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
>  				  le16_to_cpu(cl->cl_bpc));
> -	rec->e_leaf_clusters = cpu_to_le32(clusters);
> +	rec->e_leaf_clusters = cpu_to_le16(clusters);

	For a second I was worried, "what about overflow if clusters >
16bits?"  Of course, this is coming from discontig stuff which starts at
cpg, so it can't overflow.  Maybe discontig_add_extent should take
"unsigned int clusters" instead of "u32 clusters" to signify that the
size of 'clusters isn't important here?

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
