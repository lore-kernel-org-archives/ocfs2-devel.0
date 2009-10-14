From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Oct 2009 17:38:59 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091014002752.GA19960@lst.de>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091014002752.GA19960@lst.de>
Message-ID: <20091014003859.GP23257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 14, 2009 at 02:27:52AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 13, 2009 at 12:46:16PM -0700, Joel Becker wrote:
> > 	Actually, I just realized where we really differ from the other
> > filesystems.  We're clustered, but CONFIG_OCFS2_POSIX_ACL isn't a
> > feature flag.  We can, in theory, have two nodes.  Both have xattrs
> > enabled, but only one has acls compiled into the kernel.  Now we're
> > fucked.
> > 	As far as I can tell, there is no way for the non-acl driver to
> > notice that other nodes are using acls and reject the mount.  Thoughts?
> 
> So why do you allow compiling ocfs2 without ACLs at all?

	You *are* paying attention :-)  I believe this is for hysterical
raisins.  We copied ext3 on this.  I'm totally in support of ripping
ACLs out of Kconfig.

Joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
