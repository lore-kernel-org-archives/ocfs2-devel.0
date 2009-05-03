From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 3 May 2009 07:39:02 +0100
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <20090503062756.GO8822@parisc-linux.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
	<20090503062756.GO8822@parisc-linux.org>
Message-ID: <20090503063902.GR8633@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <matthew@wil.cx>
Cc: Joel Becker <joel.becker@oracle.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com

On Sun, May 03, 2009 at 12:27:57AM -0600, Matthew Wilcox wrote:
> On Sat, May 02, 2009 at 11:15:03PM -0700, Joel Becker wrote:
> > This implements reflinkat(2) and reflink(2).  See
> > Documentation/reflink.txt for a description of the reflink(2) system
> > call.
> 
> Do we need to add sys_reflink()?  Since sys_reflinkat() has a superset
> of the functionality, presumably glibc can provide both reflink() and
> reflinkat() calls, and userspace need never know that glibc is calling
> sys_reflinkat() for both.

Yes, indeed...

Another question: do we want that to work across mounpoint boundary?
It's probably OK in this case, but...
