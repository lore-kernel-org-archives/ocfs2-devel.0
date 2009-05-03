From: Matthew Wilcox <matthew@wil.cx>
Date: Sun, 3 May 2009 00:27:57 -0600
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <1241331303-23753-4-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
Message-ID: <20090503062756.GO8822@parisc-linux.org>
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

Do we need to add sys_reflink()?  Since sys_reflinkat() has a superset
of the functionality, presumably glibc can provide both reflink() and
reflinkat() calls, and userspace need never know that glibc is calling
sys_reflinkat() for both.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
