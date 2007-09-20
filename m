From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 16:26:16 2007
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: Read support for inline data
In-Reply-To: <200709192012.l8JKCHwn029357@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCHwn029357@rgmgw2.us.oracle.com>
Message-ID: <20070920232539.GD3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 07, 2007 at 02:05:51PM -0700, Mark Fasheh wrote:
> This hooks up ocfs2_readpage() to populate a page with data from an inode
> block. Direct IO reads from inline data are modified to fall back to
> buffered I/O. Appropriate checks are also placed in the extent map code to
> avoid reading an extent list when inline data might be stored.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
