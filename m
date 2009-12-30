From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 30 Dec 2009 12:34:27 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
Message-ID: <20091230203426.GA7272@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 30, 2009 at 11:30:43PM +0900, Robert Smith wrote:
> Is there a distribution available or at least what real version number of the tools, and the FS driver to I really need to make this work?
> 
> I have a 40TB partition that I want to format an cluster as a single OCFS2 cluster partition. After about 20 hours of reading and messing around with different solutions, and patches, everything seems to fall back to the following error:

	You need an ocfs2 from Linux 2.6.27 or newer.  Are you using
such a kernel?

 
> root at s2-replay01:~# time mkfs.ocfs2 -N 2 -J block64 -F -v -b 4096 -T mail -M cluster --fs-feature-level=max-features /dev/replays/replay-data 

	This looks right.  It doesn't throw you an error.

> root at s2-replay01:~# mount.ocfs2 -o inode64 /dev/replays/replay-data /data/storage/
> mount.ocfs2: Invalid argument while mounting /dev/replays/replay-data on /data/storage/. Check 'dmesg' for more information on this error.

	If your kernel driver doesn't understand inode64, it isn't new
enough.  Where did your kernel driver come from?

> I've tried compiling the new tools, and FS driver, but it looks like the most recent version is using some old constructs or API and won't compile against the most recent kernel versions without a patch.

	What do you mean by most recent version of the kernel driver?  Do
you mean any version of ocfs2 1.4?  ocfs2 1.4 does not have the support
for this.
	Go get 2.6.32.  Compile, install, and boot it.  You will now
have support for your large volume.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
