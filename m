From: Jeff Mahoney <jeffm@suse.com>
Date: Wed Oct 19 17:41:15 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051019174905.GQ11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<20051019174905.GQ11488@ca-server1.us.oracle.com>
Message-ID: <4356CC69.50706@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Joel Becker wrote:
> On Wed, Oct 19, 2005 at 03:26:24PM +0200, Lars Marowsky-Bree wrote:
>> Actually a good point. I don't think the heartbeat hierarchy is needed
>> if driven by a user-space membership.
> 
> 	Well, if it is information that some kernel component would
> want/need, then sure it would live in configfs somewhere, but not under
> OCFS2.

Yes and no. I'd like to revise my original proposal here. I think that
my proposed node hierarchy changes would be required to provide the
alternate network paths and such, but would the "active" attribute
really be required? Initially, I wanted to make the distinction between
a node's membership being removed and the node simply going down. On
further thought, I don't think this distinction actually needs to be made.

OCFS2 is aware if a node down event is expected or not by the umount
map. Therefore, it seems simple enough to allow a local node's
membership to imply a heartbeat presence.

So, how about the following:

The existing heartbeat directory structure can stay as it is. It will
only be available when o2cb is active.

/configfs/<cluster>/<uuid>/<node>/
                                  ip address
                                  port
                                  local
                                  fs slot
                                  node number

The user space heartbeat will create and remove the <node> directory on
up/down events. OCFS2 will take appropriate action as expected with the
current heartbeat implementation. I intend to simply queue the events as
they are now and use the existing callback infrastructure to distribute
them.

> 	Put succinctly: We absolutely require the minimal mkfs; mount;
> paradigm be available for our users.  We will not settle for less.
> 	How that is done we don't much care.  So if your system can't
> provide it, O2CB will continue to do so.  We'll be happy to help
> integrate with your stuff as well, as long as it doesn't compromise
> O2CB.  Then, if someone is already using your manager, they can just use
> it with OCFS2.  But anyone not already using your manager can just
> mkfs;mount; with O2CB.

I totally agree that mkfs;mount should work. It's what users expect to
work for a file system, and we don't want OCFS2 to be special cased so
much that nobody wants to deal with it. Users with more advanced
topologies can handle the additional configuration load.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDVsxpLPWxlyuTD7IRAkauAKCS+C9vzh2T8t/vI8ww682ATpzYjQCfX329
I14cD4TccpuEyek4gELeu3I=
=d6GW
-----END PGP SIGNATURE-----
