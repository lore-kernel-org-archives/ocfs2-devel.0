From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 3 May 2009 04:01:12 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
Message-ID: <20090503080112.GA27287@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com

On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
> int reflink(const char *oldpath, const char *newpath);
> 
> The reflink(2) system call creates reference-counted links.  It creates
> a new file that shares the data extents of the source file in a
> copy-on-write fashion.  Its calling semantics are identical to link(2).
> Once complete, programs see the new file as a completely separate entry.

Just send this as a manpage to Michael, no need to duplicate a
pseudo-manpage in the kernel tree.
