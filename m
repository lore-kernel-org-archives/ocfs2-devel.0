From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Oct 15 22:44:25 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] bryce commits r1573 - in trunk: .
	mount.ocfs
In-Reply-To: <20041014185029.GA31796@lst.de>
References: <200410141425.i9EEPDZS029376@oss.oracle.com>
	<20041014185029.GA31796@lst.de>
Message-ID: <20041016034415.GN27633@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 14, 2004 at 08:50:29PM +0200, Christoph Hellwig wrote:
> > +int module_loaded(char * module) {
> this check is bogus, the kernel will autload a filesystem on the first
> mount attempt.

	Not if the module fails to load without magic module parameters,
as OCFS2 still does.

Joel

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
