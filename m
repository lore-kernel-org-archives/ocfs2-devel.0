From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 3 May 2009 03:48:49 -0400
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <20090503063902.GR8633@ZenIV.linux.org.uk>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
	<20090503062756.GO8822@parisc-linux.org>
	<20090503063902.GR8633@ZenIV.linux.org.uk>
Message-ID: <20090503074849.GA20399@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, Joel Becker <joel.becker@oracle.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com

On Sun, May 03, 2009 at 07:39:02AM +0100, Al Viro wrote:
> Another question: do we want that to work across mounpoint boundary?
> It's probably OK in this case, but...

I don't think so.  Allowing any link-like semantics over mount point
boundaries will just cause problems.

Joel, can you also submit a reflink man page to Michael?
