From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Oct 2009 13:43:37 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013201210.GE31440@duck.suse.cz>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091013201210.GE31440@duck.suse.cz>
Message-ID: <20091013204337.GD23257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 13, 2009 at 10:12:10PM +0200, Jan Kara wrote:
>   We can but that's a bit separate issue. What I'm advocating is:
> When user explicitely asks for acls via a mount option and the filesystem
> does not have the feature enabled, just fail the mount instead of ignoring
> the 'acl' mount option.

	I understand the origin of your patch.  I just think we need to
consider the overall behavior so we can have a consistent story.  Don't
worry, it probably involves rejecting -oacl when we can't support it.

> > 	As far as I can tell, there is no way for the non-acl driver to
> > notice that other nodes are using acls and reject the mount.  Thoughts?
>   Hmm, this is nasty. I see two possible solutions:
> a) Use acls iff xattr feature is enabled (i.e., mount options do not
> influence whether acls are used or not), don't let kernel without
> CONFIG_OCFS2_POSIX_ACL mount the filesystem with xattr feature enabled.
> That should guarantee consistency among nodes but it can be inconvenient
> at times (you'd have to disable xattrs via tunefs.ocfs2 to temporarily
> disable acls and thus you'd loose all acl settings).
> 
> b) Introduce superblock bit 'mounted_with_acls'. The first node in the
> cluster either sets this bit or leaves it zero. Other nodes then refuse
> to mount the filesystem inconsistently with the bit setting (so if the bit
> is set, nodes without CONFIG_OCFS2_POSIX_ACL cannot mount the fs).

	Quick question: what happens on a filesystem that is run for a
little while without acls?  Eg, ext3?

    mount -oacl /dev/sda1 /ext3
    # do stuff
    umount /ext3
    mount -onoacl /dev/sda1 /ext3
    # do stuff
    umount /ext3
    mount -oacl /dev/sda1 /ext3

Is it totally screwed up?  Are the default acls sufficient such that
files created or modified while acls were off are in a sane state?
	If they are in a sane state, we can solve this with a cluster
lock.  It would require a minor revision of the locking protocol.  The
lock's LVB stores a simple boolean of whether ACLs are in use or not.
It is set by the first node.  Subsequent nodes would compare this
boolean against their acl support and continue or fail appropriately.
	If the first mounter doesn't support this lock (older locking
protocol), we simply honor the mount option as we have up until now.  If
the sysadmin mismatches acl and !acl nodes...their fault.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
