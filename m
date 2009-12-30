From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 30 Dec 2009 14:49:03 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
Message-ID: <4B3BD8DF.7020008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Robert Smith wrote:
> Dear Joel, I am using a custom compiled kernel version 2.6.32.2, using the stock ubuntu 9.10 server-config for the kernel config.
>
> root at s2-replay01:~# uname -a
> Linux s2-replay01 2.6.32.2.31337 #1 SMP Wed Dec 30 11:36:40 CST 2009 x86_64 GNU/Linux
> root at s2-replay01:~# 
>
> root at s2-replay01:~# grep OCFS2 /usr/src/linux-2.6.32.2/.config
> CONFIG_OCFS2_FS=m
> CONFIG_OCFS2_FS_O2CB=m
> CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> CONFIG_OCFS2_FS_POSIX_ACL=y
> root at s2-replay01:~# 
>
> root at s2-replay01:~# grep -i ocfs /proc/filesystems 
> nodev   ocfs2_dlmfs
>         ocfs2
> root at s2-replay01:~#
>
>
> the mkfs.ocfs2 does not throw an error. It did not throw an error on the ocfs2 1.4 modules downloaded for Redhat5 either. I've changed the OS to Ubuntu because I was having all sorts of trouble getting a kernel to compile and boot on CentOS. I'm a lot more comfortable in Debian/Ubuntu anyhow. I was hoping the absolute newest kernel would fix this issue, but it did not. I have also compiled the ocfs2-tools-1.4.3. It broke on fsck, but i was able to get the mount.ocfs2 binary to compile. I again used the mount -o inode64 option with the exact same errors as before. Appears it's still using JDB instead of JDB2.
>
>
> Anything else I can give you to help debug?
>   

We removed jdb compat code in 2.6.29 or so. So it has to be using jbd2.
One way to confirm would be to list this directory: ls /proc/fs/jbd2/.
It should show the ocfs2 devices. If not, then the kernel source is suspect.

Having said that, >16TB support while technically possible, is still being
tested. We will announce support once the testing has completed.
