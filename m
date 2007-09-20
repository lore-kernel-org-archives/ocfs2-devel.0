From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 16:18:24 2007
Subject: [Ocfs2-devel] [PATCH 11/15] ocfs2: Structure updates for
	inline data
In-Reply-To: <200709192012.l8JKCHOK012212@agmgw2.us.oracle.com>
References: <200709192012.l8JKCHOK012212@agmgw2.us.oracle.com>
Message-ID: <20070920231746.GC3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 07, 2007 at 01:58:15PM -0700, Mark Fasheh wrote:
> Add the disk, network and memory structures needed to support data in inode.

>  /*
> + * Data-in-inode header. This is only used if i_flags has
> + * OCFS2_INLINE_DATA_FL set.
> + */
> +struct ocfs2_inline_data

	I think you mean i_dyn_features.  Otherwise, it looks good.

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
