From: Christoph Hellwig <hch@lst.de>
Date: Fri, 5 Sep 2008 02:32:02 +0200
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Switch over to JBD2.
In-Reply-To: <1220497421-8606-4-git-send-email-joel.becker@oracle.com>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
	<1220497421-8606-4-git-send-email-joel.becker@oracle.com>
Message-ID: <20080905003202.GC29097@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 03, 2008 at 08:03:41PM -0700, Joel Becker wrote:
> ocfs2 wants JBD2 for many reasons, not the least of which is that JBD is
> limiting our maximum filesystem size.
> 
> It's a pretty trivial change.  Most functions are just renamed.  The
> only functional change is moving to Jan's inode-based ordered data mode.
> It's better, too.
> 
> Because JBD2 reads and writes JBD journals, this is compatible with any
> existing filesystem.  It can even interact with JBD-based ocfs2 as long
> as the journal is formated for JBD.
> 
> We provide a compatibility option so that paranoid people can still use
> JBD for the time being.  This will go away shortly.

Having to parallel codepathes switched by a little option is a really
bad idea.  Those paranoid people (if they exist at all) should just
stick to an old kernel.
