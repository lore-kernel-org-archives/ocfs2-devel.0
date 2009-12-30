From: Robert Smith <spamfree@wansecurity.com>
Date: Thu, 31 Dec 2009 07:25:37 +0900
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
	huge partition support,
	Volume might try to write to blocks beyond what jbd can address in 32
	bits)
In-Reply-To: <20091230203426.GA7272@mail.oracle.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
Message-ID: <1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dear Joel, I am using a custom compiled kernel version 2.6.32.2, using the stock ubuntu 9.10 server-config for the kernel config.

root at s2-replay01:~# uname -a
Linux s2-replay01 2.6.32.2.31337 #1 SMP Wed Dec 30 11:36:40 CST 2009 x86_64 GNU/Linux
root at s2-replay01:~# 

root at s2-replay01:~# grep OCFS2 /usr/src/linux-2.6.32.2/.config
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=y
root at s2-replay01:~# 

root at s2-replay01:~# grep -i ocfs /proc/filesystems 
nodev   ocfs2_dlmfs
        ocfs2
root at s2-replay01:~#


the mkfs.ocfs2 does not throw an error. It did not throw an error on the ocfs2 1.4 modules downloaded for Redhat5 either. I've changed the OS to Ubuntu because I was having all sorts of trouble getting a kernel to compile and boot on CentOS. I'm a lot more comfortable in Debian/Ubuntu anyhow. I was hoping the absolute newest kernel would fix this issue, but it did not. I have also compiled the ocfs2-tools-1.4.3. It broke on fsck, but i was able to get the mount.ocfs2 binary to compile. I again used the mount -o inode64 option with the exact same errors as before. Appears it's still using JDB instead of JDB2.


Anything else I can give you to help debug?


-Robert


On Dec 31, 2009, at 5:34 AM, Joel Becker wrote:

> On Wed, Dec 30, 2009 at 11:30:43PM +0900, Robert Smith wrote:
>> Is there a distribution available or at least what real version number of the tools, and the FS driver to I really need to make this work?
>> 
>> I have a 40TB partition that I want to format an cluster as a single OCFS2 cluster partition. After about 20 hours of reading and messing around with different solutions, and patches, everything seems to fall back to the following error:
> 
> 	You need an ocfs2 from Linux 2.6.27 or newer.  Are you using
> such a kernel?
> 
> 
>> root at s2-replay01:~# time mkfs.ocfs2 -N 2 -J block64 -F -v -b 4096 -T mail -M cluster --fs-feature-level=max-features /dev/replays/replay-data 
> 
> 	This looks right.  It doesn't throw you an error.
> 
>> root at s2-replay01:~# mount.ocfs2 -o inode64 /dev/replays/replay-data /data/storage/
>> mount.ocfs2: Invalid argument while mounting /dev/replays/replay-data on /data/storage/. Check 'dmesg' for more information on this error.
> 
> 	If your kernel driver doesn't understand inode64, it isn't new
> enough.  Where did your kernel driver come from?
> 
>> I've tried compiling the new tools, and FS driver, but it looks like the most recent version is using some old constructs or API and won't compile against the most recent kernel versions without a patch.
> 
> 	What do you mean by most recent version of the kernel driver?  Do
> you mean any version of ocfs2 1.4?  ocfs2 1.4 does not have the support
> for this.
> 	Go get 2.6.32.  Compile, install, and boot it.  You will now
> have support for your large volume.
> 
> Joel
> 
> -- 
> 
> "Here's a nickle -- get yourself a better X server."
> 	- Keith Packard
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
