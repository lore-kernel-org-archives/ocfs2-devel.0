From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 17:13:51 2007
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Write support for
	directories with inline data
In-Reply-To: <200709192012.l8JKCHnX012247@agmgw2.us.oracle.com>
References: <200709192012.l8JKCHnX012247@agmgw2.us.oracle.com>
Message-ID: <20070921001315.GG3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 13, 2007 at 04:33:54PM -0700, Mark Fasheh wrote:
> Create all new directories with OCFS2_INLINE_DATA_FL and the inline data
> bytes formatted as an empty directory. Inode size field reflects the actual
> amount of inline data available, which makes searching for dirent space
> very similar to the regular directory search.
> 
> Inline-data directories are automatically pushed out to extents on any
> insert request which is too large for the available space.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
