From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 9 Jul 2010 14:56:33 -0700
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: make xattr extension work
 with new local alloc reservation.
In-Reply-To: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
References: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100709215633.GB4520@mail.oracle.com>
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

	Let me know if and when these patches pass the xattr test suite.
IRC is fine.  They look good, so they're queued up.

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
