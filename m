From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 17 Nov 2008 15:36:43 -0800
Subject: [Ocfs2-devel] [Pacemaker] Re: [Cluster-devel] [RFC] Splitting
	cluster.git into separate	projects/trees
In-Reply-To: <491D45FC.4090909@redhat.com>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<491D45FC.4090909@redhat.com>
Message-ID: <20081117233643.GD8378@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 14, 2008 at 09:33:48AM +0000, Christine Caulfield wrote:
> Fabio M. Di Nitto wrote:
> > Hi everybody,
> > 
> > as discussed and agreed at the Cluster Summit we need to split our tree
> > to make life easier in the long run (etc. etc.).

Thanks for taking this on Fabio.


> > = third approach =
> > 
> > We copy cluster.git N times for each (sub) project, clean the master
> > branch to match only that (sub)project.
> > 
> > Pro:
> >  - very clean tree from checkout
> >  - each (sub) project is really separated and will have its own
> > identity.
> >  - external users don't need to build the whole tree.
> >  - easier to fine tune access to each single component (for example we
> > can allow user foo to access dlm but not gfs... or whatever combination)
> > 
> > Cons:
> >  - more complex process to perform cherry-pick between branches.
> >  - higher risk to commit fixes in one branch and forget in another.
> >  - requires a lot more developer attention.
> 
> 
> I think I would votes for 3, 1, 2 in that order.
> 
> 3 is definitely the best option IMHO. The cons don't make much
> difference really - as I understand it, we're not splitting branches but
> projects so there will be no, or very little, need to copy fixes across
> git trees. Even for the few occasions when it might be necessary, git is
> quite capable of generating usable patches.

I completely agree. Also, yeah the cons don't seem like real cons.

Split out repos for each component is a rather common development model for
free software projects, so I think we're in good company there.

1 and 2 don't really seem like viable long term options to me.
	--Mark

--
Mark Fasheh
