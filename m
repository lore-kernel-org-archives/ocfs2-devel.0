From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 6 Jul 2006 13:43:29 -0700
Subject: [Ocfs2-devel] [-mm patch]
	fs/ocfs2/inode.c:ocfs2_refresh_inode(): remove unused variable
In-Reply-To: <20060706203708.GQ26941@stusta.de>
References: <20060703030355.420c7155.akpm@osdl.org>
	<20060706203708.GQ26941@stusta.de>
Message-ID: <20060706204329.GD29686@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com

On Thu, Jul 06, 2006 at 10:37:08PM +0200, Adrian Bunk wrote:
> On Mon, Jul 03, 2006 at 03:03:55AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.17-mm5:
> >...
> > +inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default.patch
> >...
> >  Misc updates.
> >...
> 
> This patch removes a no longer used variable.
Ahh, the osb was only used to set i_blksize, which of course the inode-diet
patches removed. Looks fine to me - thanks Adrian.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
