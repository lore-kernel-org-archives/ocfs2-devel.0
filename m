From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 2 Jun 2009 11:56:49 -0700
Subject: [Ocfs2-devel] Anything I'm missing for 2.6.31?
In-Reply-To: <20090602122547.GC15010@duck.suse.cz>
References: <20090602010636.GB32688@mail.oracle.com>
	<20090602122547.GC15010@duck.suse.cz>
Message-ID: <20090602185649.GC31976@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 02, 2009 at 02:25:48PM +0200, Jan Kara wrote:
> On Mon 01-06-09 18:06:36, Joel Becker wrote:
> > 	We're coming up on the next merge window, and I only have a
> > couple tiny fixes for ocfs2.  I thought I'd list up what I know is
> > outstanding, and I was hoping to find out if I was missing anything.  If
> > I am, I need to get it in linux-next and set for the merge window ASAP.
>   I've just sent off a patch series that may be worth merging for 2.6.31...
> It contains some quota fixes and lockdep support for cluster locks.

	I'll have a look.  Fixes for sure, the other stuff may or may
not be for this late in the cycle.

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
