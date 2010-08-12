From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Aug 2010 02:43:50 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100812094350.GB6561@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 12, 2010 at 05:03:16PM +0800, Tao Ma wrote:
> In ocfs2, we now only cache the inodes for global system file
> and the system inodes for our own slot. But we have some cases
> that we may need to access system inodes of other nodes, such
> as orphan scan, inode steal etc.

	I don't see why you don't extend the existing cache and make one
cache.  Make it live the lifetime of the filesystem.  No real reason to
a) have to caches or b) limit the system inodes we might cache.  If we
don't have the lock we're going to re-read them anyway.

Joel

-- 

	Pitchers and catchers report.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
