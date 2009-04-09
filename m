From: David Teigland <teigland@redhat.com>
Date: Thu, 9 Apr 2009 11:22:28 -0500
Subject: [Ocfs2-devel] ocfs2_controld.cman
In-Reply-To: <20090408222237.GC8561@mail.oracle.com>
References: <20090408213317.GC11662@redhat.com>
	<20090408222237.GC8561@mail.oracle.com>
Message-ID: <20090409162227.GB21456@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 08, 2009 at 03:22:37PM -0700, Joel Becker wrote:
> > This isn't a correct assumption.  It's possible that two or more nodes
> > joining at once will become initial members together.  (I realize that
> > it's a very convenient assumption to make after using it in previous
> > pre-cpg programs, and it may take a fair amount of work to do without.)
> 
> Well, this is going to be fun.  I have to figure out which daemon is
> the "first", and now it's just racy.  I could swear that someone told
> me cpg would guarantee i see the joins in order, not at the same time.

It may just work to have both race to create the checkpoint, the loser should
get an error back from create (I haven't tried it, but I'd expect it to work
that way.)

Dave
