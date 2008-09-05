From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 4 Sep 2008 18:40:10 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Switch over to JBD2.
In-Reply-To: <20080905003202.GC29097@lst.de>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
	<1220497421-8606-4-git-send-email-joel.becker@oracle.com>
	<20080905003202.GC29097@lst.de>
Message-ID: <20080905014010.GB28061@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 05, 2008 at 02:32:02AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 03, 2008 at 08:03:41PM -0700, Joel Becker wrote:
> > ocfs2 wants JBD2 for many reasons, not the least of which is that JBD is
> > limiting our maximum filesystem size.
> > 
> > It's a pretty trivial change.  Most functions are just renamed.  The
> > only functional change is moving to Jan's inode-based ordered data mode.
> > It's better, too.
> > 
> > Because JBD2 reads and writes JBD journals, this is compatible with any
> > existing filesystem.  It can even interact with JBD-based ocfs2 as long
> > as the journal is formated for JBD.
> > 
> > We provide a compatibility option so that paranoid people can still use
> > JBD for the time being.  This will go away shortly.
> 
> Having to parallel codepathes switched by a little option is a really
> bad idea.  Those paranoid people (if they exist at all) should just
> stick to an old kernel.

	This will live exactly as long as it takes us to stress test
JBD2.  Something like .28 will have this option and .29 will drop it.

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
