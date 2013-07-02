From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 17:57:44 -0700
Subject: [Ocfs2-devel] [RESENT PATCH 4/4] ocfs2: adjust switch_case
 syntax at o2net_state_change()
In-Reply-To: <20130701162228.e47209b0012101bab77b27ca@linux-foundation.org>
References: <51CE5C0F.8030701@oracle.com> <20130701230421.GE965@localhost>
	<20130701162228.e47209b0012101bab77b27ca@linux-foundation.org>
Message-ID: <20130702005743.GI965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 01, 2013 at 04:22:28PM -0700, Andrew Morton wrote:
> On Mon, 1 Jul 2013 16:04:21 -0700 Joel Becker <jlbec@evilplan.org> wrote:
> 
> > On Sat, Jun 29, 2013 at 12:01:19PM +0800, Jeff Liu wrote:
> > > From: Jie Liu <jeff.liu@oracle.com>
> > > 
> > > Adjust switch..case syntax at o2net_state_change to meet
> > > the kernel coding standard.
> > > 
> > > s/printk/pr_info/.
> > > 
> > > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > 
> > 	Switching to pr_info() hasn't been discussed as part of the
> > project.  Let's have that conversation elsewhere.
> > 
> 
> I reverted that bit.
> 
> It was wrong anyway:
> 
> > > +		pr_info(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
> > > +			" shutdown, state %d\n",
> > > +			SC_NODEF_ARGS(sc), sk->sk_state);
> 
> Should remove the "KERN_INFO " now.
> 
> 
> Switching to pr_foo is a good idea, I find.  A nice thing about it is
> that it reduces the length of the lines quite a lot, and printk
> statements are often quite long lines.  The net effect is that a *lot*
> of nasty make-it-fit-in-80-columns tricks just vanish.

	That's good to know.

Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

			http://www.jlbec.org/
			jlbec at evilplan.org
