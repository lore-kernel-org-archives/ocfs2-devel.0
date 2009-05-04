From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 3 May 2009 19:53:40 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <20090503063902.GR8633@ZenIV.linux.org.uk>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-4-git-send-email-joel.becker@oracle.com>
	<20090503062756.GO8822@parisc-linux.org>
	<20090503063902.GR8633@ZenIV.linux.org.uk>
Message-ID: <20090504025340.GF24653@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com

On Sun, May 03, 2009 at 07:39:02AM +0100, Al Viro wrote:
> Another question: do we want that to work across mounpoint boundary?
> It's probably OK in this case, but...

	I don't think we want it working across mountpoints, just like
link(2).  I thought I checked for that in sys_reflinkat().

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
