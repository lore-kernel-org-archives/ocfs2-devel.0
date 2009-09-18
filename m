From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 18 Sep 2009 11:39:26 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <1253294613.31359.136.camel@hermosa>
References: <20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<20090918014333.GD15620@mail.oracle.com>
	<1253294613.31359.136.camel@hermosa>
Message-ID: <20090918183926.GB8551@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Fri, Sep 18, 2009 at 11:23:33AM -0600, Peter W. Morreale wrote:
> On Thu, 2009-09-17 at 18:43 -0700, Joel Becker wrote:
> > On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
> > > Why would anybody want to hide it at all? Why even the libc hiding?
> > > 
> > > Nobody is going to use this except for special apps. Let them see what 
> > > they can do, in all its glory. 
> > 
> > 	I expect everyone will use this through cp(1), so that cp(1) can
> > try to get server-side copy on the network filesystms.
> > 	Speaking of "all its glory", what we have now is:
> > 
> > int sys_copyfileat(int oldfd, const char *oldname, int newfd,
> >                    const char *newname, int flags, int atflags)
> 
> 
> Would it be worthwhile to consider adding an offset and length?  
> 
> Then we get dd as well. (potentially) 

	I'm with Linus that a range attribute really makes this
complicated.  I also think it doesn't work well with a call that is
supposed to create newname.

Joel

-- 

	Pitchers and catchers report.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
