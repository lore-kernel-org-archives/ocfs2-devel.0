From: Jeff Mahoney <jeffm@suse.com>
Date: Wed Oct 19 16:30:26 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051019132624.GI24589@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
Message-ID: <4356BBE8.2080904@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Lars Marowsky-Bree wrote:
> Actually a good point. I don't think the heartbeat hierarchy is needed
> if driven by a user-space membership.

If we're to provide membership information on a per file system basis,
we'll need some way to distinguish between them. The hierarchy may not
matter in the case of the o2cb global heartbeat, but it does for the
userspace heartbeat.

> OCFS2 doesn't register with us in this model; _we_ drive OCFS2 and
> provide it with the events; we manage it, so we know it's there.

No, OCFS2 needs to register with userspace.

The userspace heart beat should only care about nodes where the file
system is actually mounted. Otherwise, if a random node that has the
ability to mount a file system but doesn't actually have it mounted
could cause heartbeat events across the cluster. That shouldn't happen.

In order to do this, I think that at mount time, we should call out to
user space to tell it to start caring about this node for a particular
heart beat group. When the file system is umounted, we call out again
and tell it to stop caring.

Only using the cluster manager to mount or umount a file system isn't an
acceptable use pattern. OCFS2 shouldn't become so special cased that
it's a pain to work with. Ideally, it should only be slightly more
difficult to configure than o2cb is now. mount -t ocfs2 should work with
no additional effort for the common case. There should be a default
OCFS2 configuration that we can use for common mounts, and then special
cased configurations for more advanced topologies. We can pass out the
UUID as a parameter; I don't think this should be too difficult to do.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDVrvoLPWxlyuTD7IRAibPAKCMUrfsy4WMUBDpyZ0BKqNy9KcNjwCggxE1
bZbDDewALUQBLnswO+8Mnio=
=uDuP
-----END PGP SIGNATURE-----
