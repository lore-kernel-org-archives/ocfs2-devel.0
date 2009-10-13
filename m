From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 13 Oct 2009 16:50:21 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013230241.GI23257@mail.oracle.com>
References: <20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091013201210.GE31440@duck.suse.cz>
	<20091013204337.GD23257@mail.oracle.com>
	<20091013223004.GA12273@duck.suse.cz>
	<20091013225014.GV11402@wotan.suse.de>
	<20091013230241.GI23257@mail.oracle.com>
Message-ID: <20091013235021.GW11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 13, 2009 at 04:02:41PM -0700, Joel Becker wrote:
> On Tue, Oct 13, 2009 at 03:50:14PM -0700, Mark Fasheh wrote:
> > Hmm, regarding this part of the discussion - how do we know if the admin
> > actually wants the proposed behavior? Presumably the admin in our ext3
> > example has a good reason for working without acls for a time. Perhaps the
> > same admin would like that ability on a cluster node, without having to
> > unmount from all acl nodes in the cluster...
> 
> 	I would think anyone would want the acl behavior coherent across
> the cluster.  Otherwise node 1 is setting an acl that node 2 promptly
> ignores?  Yuk!  Especially since that admin could have accidentally
> booted a non-ACL ocfs2 and not realize it?

Well, we have to ask ourselves what the (theoretical) person remounting ext3
without acls is doing that for. This isn't about the ext3 rules for mounting
with acls as much as it's a question of "why would this happen?".


> > If we add cluster locking / messaging, etc to disallow this, we're removing
> > a potentially valid use case.
> 
> 	I don't know that it is valid.  But if we want to support it, we
> can clearly differentiate between "my kernel doesn't support this" and
> "I support it, but I was told noacl".

Right, I am theorizing about the case of "I support it, but I was told
noacl" which I don't see a good reason to disallow (even if a mount is
mounted acl elsewhere)

It might make more sense to look at this from the other direction. Say I'm
a cluster admin and my nodes aren't currently using acls. Perhaps at some
point in the future, I want to enable them (maybe so I can deploy a new app
on my shared disk). Today, I could do this without taking down the entire
cluster - I'd simply enable acls one node at a time. Once they were all back
up with acl support, I could deploy my app without having lost any downtime.
If we disallow this situation, I'd have to bring down the entire cluster to
enable acls.

Considering how much time we put into online-fs-operations, I say we keep
this ability. We can market it as "Ocfs2 supports online acl enablement!" ;)


Btw, are we all agreed about Jan's original patch?
	--Mark

--
Mark Fasheh
