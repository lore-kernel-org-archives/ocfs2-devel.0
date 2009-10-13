From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Oct 2009 16:02:41 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013225014.GV11402@wotan.suse.de>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091013201210.GE31440@duck.suse.cz>
	<20091013204337.GD23257@mail.oracle.com>
	<20091013223004.GA12273@duck.suse.cz>
	<20091013225014.GV11402@wotan.suse.de>
Message-ID: <20091013230241.GI23257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 13, 2009 at 03:50:14PM -0700, Mark Fasheh wrote:
> Hmm, regarding this part of the discussion - how do we know if the admin
> actually wants the proposed behavior? Presumably the admin in our ext3
> example has a good reason for working without acls for a time. Perhaps the
> same admin would like that ability on a cluster node, without having to
> unmount from all acl nodes in the cluster...

	I would think anyone would want the acl behavior coherent across
the cluster.  Otherwise node 1 is setting an acl that node 2 promptly
ignores?  Yuk!  Especially since that admin could have accidentally
booted a non-ACL ocfs2 and not realize it?

> If we add cluster locking / messaging, etc to disallow this, we're removing
> a potentially valid use case.

	I don't know that it is valid.  But if we want to support it, we
can clearly differentiate between "my kernel doesn't support this" and
"I support it, but I was told noacl".

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
