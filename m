From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Sep 21 09:45:40 2005
Subject: [Ocfs2-devel] Re: [patch] stop inotify from sending random
	DELETE_SELF event under load
In-Reply-To: <20050921091738.GA28289@infradead.org>
References: <Pine.LNX.4.58.0509201108120.2553@g5.osdl.org>
	<20050920182249.GP7992@ftp.linux.org.uk>
	<Pine.LNX.4.58.0509201234560.2553@g5.osdl.org>
	<1127256814.749.5.camel@vertex>
	<20050921010154.GR7992@ftp.linux.org.uk>
	<1127266907.3950.5.camel@vertex>
	<20050921023601.GT7992@ftp.linux.org.uk>
	<20050921083525.GB27254@infradead.org>
	<20050921091524.GG26425@ca-server1.us.oracle.com>
	<20050921091738.GA28289@infradead.org>
Message-ID: <20050921144538.GI26425@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>, John McCutchan <ttb@tentacle.dhs.org>, Linus Torvalds <torvalds@osdl.org>, Ray Lee <ray@madrabbit.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Robert Love <rml@novell.com>, ocfs2-devel@oss.oracle.com

On Wed, Sep 21, 2005 at 10:17:38AM +0100, Christoph Hellwig wrote:
> The real fix would be to put an equivalent of OCFS2_INODE_MAYBE_ORPHANED
> into struct inode.  That way it could be shared by other clustered
> filesystems aswell, and OCFS2 had no need to implement ->drop_inode.

	Or change the VFS patterns to allow lookup and validation of the
inode before choosing the generic_drop/generic_delete path.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
