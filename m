From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb 23 18:27:21 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in nm.c
In-Reply-To: <20040224002331.GG1421@ca-server1.us.oracle.com>
References: <200402200413.i1K4DwFC004269@penguin.co.intel.com>
	<20040224002331.GG1421@ca-server1.us.oracle.com>
Message-ID: <20040224002707.GA17093@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 Mon, Feb 23, 2004 at 04:23:31PM -0800, Mark Fasheh wrote:
> On Thu, Feb 19, 2004 at 08:13:58PM -0800, Rusty Lynch wrote:
> > The following patch enables inode syncing on 2.6 kernels in the 
> > nm.c file.
> > 
> >     --rusty
> 
> Damn, I missed some of the LINUX_2_5 conditionals that stayed in even after
> the patch... You mind sending me a patch that replaces the rest of them in
> nm.c? I've committed the other parts of the patch so you don't have to worry
> about that :)
> 
> In fact, feel free to send me patches to remove them in the rest of the 
> files ;)
> 	--Mark

When svn syncs I'll go through and catch all the remaining LINUX_2_5's.
