From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:27:38 2007
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Small refactor of truncate
	zeroing code
In-Reply-To: <200709192012.l8JKCF5w029275@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCF5w029275@rgmgw2.us.oracle.com>
Message-ID: <20070920182702.GE30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 07, 2007 at 02:20:45PM -0700, Mark Fasheh wrote:
> We'll want to reuse most of this when pushing inline data back out to an
> extent. Keeping this part as a seperate patch helps to keep the upcoming
> changes for write support uncluttered.
> 
> The core portion of ocfs2_zero_cluster_pages() responsible for making sure a
> page is mapped and properly dirtied is abstracted out into it's own
> function, ocfs2_map_and_dirty_page(). Actual functionality doesn't change,
> though zeroing becomes optional.
> 
> We also turn part of ocfs2_free_write_ctxt() into  a common function for
> unlocking and freeing a page array. This operation is very common (and
> uniform) for Ocfs2 cluster sizes greater than page size, so it makes sense
> to keep the code in one place.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
