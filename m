From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 3 May 2009 04:04:50 -0400
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <1241331303-23753-4-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
Message-ID: <20090503080450.GC27287@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat, May 02, 2009 at 11:15:03PM -0700, Joel Becker wrote:
> This implements reflinkat(2) and reflink(2).  See
> Documentation/reflink.txt for a description of the reflink(2) system
> call.
> 
> XXX: Currently only adds the x86_32 linkage.  The rest of the
> architectures belong here too.

As mentioned by willy, no need for the sys_reflink syscall.  Also
no really good reason to split the support up into three patches,
one is enough.
