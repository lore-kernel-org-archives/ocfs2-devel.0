From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:41:24 2007
Subject: [Ocfs2-devel] [PATCH 05/15] ocfs2: Pass raw u64 to filldir
In-Reply-To: <200709192012.l8JKCGhF012172@agmgw2.us.oracle.com>
References: <200709192012.l8JKCGhF012172@agmgw2.us.oracle.com>
Message-ID: <20070920184047.GH30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 10, 2007 at 05:30:26PM -0700, Mark Fasheh wrote:
> filldir_t can take this, so don't turn de->inode into a 32 bit value. Right
> now this doesn't make a difference since no ocfs2 inodes overflow that, but
> it could be a nasty surprise later on if some kernel code is calling
> ocfs2_dir_foreach_blk() and expecting real inode numbers back...

	How come we don't have inodes overflowing 32bits?  Is this a
limit imposed elsewhere?  Refresh my (swiss cheese) memory :-)
	I actually think that the -EOVERFLOW from filldir(7) is better
than our truncated ino, so I still say

Signed-off-by: Joel Becker <joel.becker@oracle.com>

-- 

Viro's Razor:
	Any race condition, no matter how unlikely, will occur just
	often enough to bite you.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
