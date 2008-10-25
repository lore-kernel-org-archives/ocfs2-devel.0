From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 18:54:28 -0700
Subject: [Ocfs2-devel] Bug in OCFS2 umount code
In-Reply-To: <20081024224839.GA10359@duck.suse.cz>
References: <20081024215702.GA10038@duck.suse.cz>
	<20081024224025.GF9302@mail.oracle.com>
	<20081024224839.GA10359@duck.suse.cz>
Message-ID: <20081025015428.GI9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 25, 2008 at 12:48:39AM +0200, Jan Kara wrote:
> On Fri 24-10-08 15:40:25, Joel Becker wrote:
> > 	So I don't see a bug in the code as I have it here in my tree.
> > I'm going to go check your quota patches to see if perhaps you jump to
> > read_super_error after s_root is set.  If so, we can just reorganize
> > that.  If not, we'll have to figure out what particular mount failure is
> > causing your problem, so we can see what's happening.
>   Ah, OK. I've noticed that when quota failed to turn on for some reason.
> So you are probably right, that I've added an error path which was not
> there. Just when I was looking at the mount code I didn't notice that
> I'm doing something different from the rest of the function :) Sorry for
> the noise.

	It's not noise.  We didn't know until we checked it out :-)
Don't worry about bothering us.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
