From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 13 Oct 2009 15:50:14 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013223004.GA12273@duck.suse.cz>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091013201210.GE31440@duck.suse.cz>
	<20091013204337.GD23257@mail.oracle.com>
	<20091013223004.GA12273@duck.suse.cz>
Message-ID: <20091013225014.GV11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 14, 2009 at 12:30:04AM +0200, Jan Kara wrote:
> > 	Quick question: what happens on a filesystem that is run for a
> > little while without acls?  Eg, ext3?
> > 
> >     mount -oacl /dev/sda1 /ext3
> >     # do stuff
> >     umount /ext3
> >     mount -onoacl /dev/sda1 /ext3
> >     # do stuff
> >     umount /ext3
> >     mount -oacl /dev/sda1 /ext3
> > 
> > Is it totally screwed up?  Are the default acls sufficient such that
> > files created or modified while acls were off are in a sane state?
>   For ext3, when you mount with noacl, acls are not inherited for newly
> created files and directories, obviously they are not enforced but
> apart from that they stay correct.

Thanks for clearing that up Jan.


> > 	If they are in a sane state, we can solve this with a cluster
> > lock.  It would require a minor revision of the locking protocol.  The
> > lock's LVB stores a simple boolean of whether ACLs are in use or not.
> > It is set by the first node.  Subsequent nodes would compare this
> > boolean against their acl support and continue or fail appropriately.
> > 	If the first mounter doesn't support this lock (older locking
> > protocol), we simply honor the mount option as we have up until now.  If
> > the sysadmin mismatches acl and !acl nodes...their fault.
>   Yes, this looks like a reasonable choice.

Hmm, regarding this part of the discussion - how do we know if the admin
actually wants the proposed behavior? Presumably the admin in our ext3
example has a good reason for working without acls for a time. Perhaps the
same admin would like that ability on a cluster node, without having to
unmount from all acl nodes in the cluster...

If we add cluster locking / messaging, etc to disallow this, we're removing
a potentially valid use case.
	--Mark


--
Mark Fasheh
