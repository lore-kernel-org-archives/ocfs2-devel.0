From: Jeff Mahoney <jeffm@suse.com>
Date: Tue Oct 18 18:20:16 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018221849.GN11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
Message-ID: <43558422.9040607@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Joel Becker wrote:
> On Tue, Oct 18, 2005 at 05:56:27PM -0400, Jeff Mahoney wrote:
>> I'll start with an idea of what I'd like to see the configfs space look
>> like, since I think it will probably illustrate it best:
>>
>> /config/cluster/ocfs2/<fs uuid>/<node>/
> 
> 	If you are treating each mount as a 'cluster', the ocfs2 path
> element is pretty redundant, and /config/cluster/<fs uuid> would
> suffice.

I was leaving /config/cluster as a global subsystem, since there may be
other users of the namespace in the future. I wasn't using ocfs2 as an
identifier of a cluster name, but rather the name of the particular
cluster subsystem.

> 	Given that heartbeat regions can and should be shared, you need
> a way to describe this.  We don't have userspace doing global heartbeat
> yet, but there is no reason that all OCFS2 volumes can't share one
> heartbeat region (see
> http://oss.oracle.com/projects/ocfs2-tools/src/branches/global-heartbeat/documentation/o2cb/).

As Lars mentioned in his reply, part of my plan is to remove the
heartbeating aspect completely when the userspace clustering is enabled.
The node manager would be fed membership information from userspace,
where it knows what the network topology and storage configuration is.
Quorum and fencing decisions would be made in userspace using the
algorithms already implemented and tested.

Since there are any number of possible topologies, I'd like the
granularity for controlling membership to be at the per-file system level.

> 	Have you also considered what this will or won't do to possible
> interaction with the CMan stack?  We'd love OCFS2 to handle both stacks.

I'm not really familiar with the CMan stack, but I was hoping that the
configuration I described would be easy enough for any userspace cluster
manager to handle. Lars and Andrew Beekhof are working with me on the
cluster side of things, so they'd be more familiar with the details here.

> 	Finally, have you considered the user barriers to this?  The
> absolute bottom-line goal of O2CB is the minimum input by the user.  For
> this to work, the user should not have to see the plethora of XML config
> files that heartbeat has (or at least, used to have).  I'm talking about
> the user-visible part here, not the technical reality.  The O2CB
> frontend or some other piece of software can take the user's name:ip
> node mapping and turn it into whatever XML it needs, but the user
> shouldn't have to do anything more than ocfs2console requires them
> today.

I'm not sure if we're on the same page here. I'm not proposing a
complete replacement of o2cb. I'm proposing we keep o2cb and supplement
it with the ability to handle input from a userspace cluster manager,
regardless of what that cluster manager is. The implementation of that
cluster manager should be completely outside the scope of the file
system. I'm envisioning the cluster manager choice (userspace or o2cb)
as a compile time option, but I suppose it could be a module load time
option as well.

The differences to o2cb should be minimal, and absolutely hidden from
the user unless they desire more functionality, such as alternate
network paths.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDVYQhLPWxlyuTD7IRAijgAJ9GKB9qk1nliD39da4SJFKzBIYs+QCeJ3nX
tWMar1L44rcOBlw1yYx8g1Y=
=3Q1D
-----END PGP SIGNATURE-----
