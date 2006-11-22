From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov 22 21:22:36 2006
Subject: [Ocfs2-devel] Local FS mount
In-Reply-To: <20061123012604.GJ26014@ca-server1.us.oracle.com>
References: <4564DF42.2010905@oracle.com>
	<20061123012604.GJ26014@ca-server1.us.oracle.com>
Message-ID: <20061123052233.GI30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 22, 2006 at 05:26:04PM -0800, Joel Becker wrote:
> On Wed, Nov 22, 2006 at 03:37:38PM -0800, Sunil Mushran wrote:
> > http://oss.oracle.com/osswiki/OCFS2/DesignDocs/LocalMount
> 	Sunil was bothered by something, though.  There was no way to
> determine if an existing mount was local.  So he added a ghost mount
> option:
> 
>   1) mount learns, via -t, fstab, or blkid, that this is an ocfs2
>      filesystem and calls mount.ocfs2
>   2) mount.ocfs2 reads the superblock and notices the INCOMAT flag for
>      local mounts
>   3) mount.ocfs2 does NOT start heartbeat
>   4) mount.ocfs2 adds "mount=local" to the options list
>   5) mount.ocfs2 calls sys_mount(2) with the additional option
>   6) ocfs2_fill_super() notices the INCOMPAT flag and validates it
>      against the "mount=local" option.  It still doesn't worry
>      about checking the heartbeat
> 
> This ghost mount option appears in the output of /proc/mounts and calls
> to mount(8) with no arguments.  This allows the user to see "hey, it's a
> local mount!"
I don't see why this is such a big deal that it requires a magic mount
option. If the user really cares, he/she can run a single debugfs.ocfs2
command against the file system. Also, we can add code to 'mounted.ocfs2' to
indicate whether a file system is 'local' or not.


> 	This bothered me for two reasons.  First, a "magic" option that
> the user never specified is a bit "dirty".  There ought to be a better
> way.  More importantly, though, there is no difference to the user that
> they tried to mount a local filesystem.  They didn't specify it, so they
> may expect it to work clustered.  Or, they may be expecting a local
> filesystem, but it is actually a clustered one.
It bothers me too, but the scheme you described seems to just add much more
code, complexity and engineering for a gain which we already have with the
mount options. Two file system types just to describe a single format option
is way overkill. Not to mention that it would require us to push changes out
to blkid, etc. Anybody who has a script which parses ocfs2 out of a mount
command would have to change that too. I suppose we'd also have to start
distributing a mount.ocfs2local.

By the way - the user _did_ specify that they wanted a local file system
when they ran mkfs.ocfs2. Or when it ran as part of an installer, or a gui,
or whatever.

So, if the user has at least two other tools (debugfs.ocfs2, mounted.ocfs2)
they can use, then there's no reason for either one. By the way, I bet most
people will make 'local' file systems on non shared disks and will thus
understand implicitely which disks hold 'local' ocfs2 volumes when they type
'mount'.

If we inisist that we must make it such that users know 100% in a very
explicit way via mount(8) whether an ocfs2 mount is local, then adding a
mount option is the better way imho.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
