From: Greg KH <greg@kroah.com>
Date: Thu, 13 Dec 2007 00:07:34 -0000
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs	canonical
In-Reply-To: <20071212225250.GD28607@ca-server1.us.oracle.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
	<91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
	<20071211190633.GA27037@kroah.com>
	<91b13c310712111702x76553ed1w94d044e5b5d0506f@mail.gmail.com>
	<20071212222857.GF16474@kroah.com>
	<20071212225250.GD28607@ca-server1.us.oracle.com>
Message-ID: <20071213000358.GA412@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 12, 2007 at 02:52:50PM -0800, Mark Fasheh wrote:
> On Wed, Dec 12, 2007 at 02:28:57PM -0800, Greg KH wrote:
> > > The sysfs entries of ocfs2 are under /sys/oc2b, but I think they
> > > generally should be under /sys/fs/oc2b, aren't they?
> > 
> > Yes, they should be, it looks like someone messed up putting them in the
> > sysfs root directory.
> 
> 'o2cb' refers to the stuff in ocfs2_nodemanager, so we wanted to keep it out
> of the fs namespace (think more "cluster" than "file system").
> 
> We felt at the time (and still do) that it was better than polluting
> /sys/fs/ with non file system related things.
> 
> Also, I feel that for perspective, I should mention that this layout isn't
> anything new - we've been doing this for a while.

Then you all have been ignoring the patches that are in -mm that move
this directory under /sys/fs/ for quite some time now :)

> > > But as Joel said, this change will break ocfs2-tools, so the decision
> > > was not made.
> > 
> > It should be pretty simple to change the tools to work for both places,
> > right?
> 
> Changing a path (or just testing two of them) isn't a big deal, the problem
> is that existing versions of ocfs2-tools will break very badly. That's
> clearly unnaceptable for a production file system.

Update the tools today, and then let the kernel change happen in a few
months.  Not that big of a deal.

thanks,

greg k-h
