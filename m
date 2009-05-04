From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 3 May 2009 19:53:02 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <20090503062756.GO8822@parisc-linux.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
	<20090503062756.GO8822@parisc-linux.org>
Message-ID: <20090504025302.GE24653@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

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

	Sure, that works.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
