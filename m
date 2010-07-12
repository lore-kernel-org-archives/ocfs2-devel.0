From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:33:05 -0700
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: make xattr extension work
 with new local alloc reservation.
In-Reply-To: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
References: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100712183305.GD12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 09, 2010 at 02:53:11PM +0800, Tao Ma wrote:
> The old ocfs2_xattr_extent_allocation is too optimistic about
> the clusters we can get. So actually if the file system is
> too fragmented, ocfs2_add_clusters_in_btree will return us
> with EGAIN and we need to allocate clusters once again.
> 
> So this patch change it to a while loop so that we can allocate
> clusters until we reach clusters_to_add.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
