From: Christoph Hellwig <hch@lst.de>
Date: Wed, 14 Oct 2009 02:27:52 +0200
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013194615.GA23257@mail.oracle.com>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
Message-ID: <20091014002752.GA19960@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 13, 2009 at 12:46:16PM -0700, Joel Becker wrote:
> 	Actually, I just realized where we really differ from the other
> filesystems.  We're clustered, but CONFIG_OCFS2_POSIX_ACL isn't a
> feature flag.  We can, in theory, have two nodes.  Both have xattrs
> enabled, but only one has acls compiled into the kernel.  Now we're
> fucked.
> 	As far as I can tell, there is no way for the non-acl driver to
> notice that other nodes are using acls and reject the mount.  Thoughts?

So why do you allow compiling ocfs2 without ACLs at all?
