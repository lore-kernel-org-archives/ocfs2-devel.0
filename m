From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 30 Dec 2009 19:42:43 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
Message-ID: <20091231034243.GA2560@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 31, 2009 at 07:25:37AM +0900, Robert Smith wrote:
> Dear Joel, I am using a custom compiled kernel version 2.6.32.2, using the stock ubuntu 9.10 server-config for the kernel config.

	Hmm...

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

	What do you get from 'modinfo ocfs2'?  You should see jbd2 as a
dependency.  If ocfs2 is loaded, jbd2 should be as well.  Sunil is
right, 2.6.32 shouldn't have it any other way.
	Let's check on your filesystem itself.  How about the output of
'tunefs.ocfs2 -Q "%M %H %O\n" /dev/replays/replay-data'?  That should
include strict-journal-super.  Then check 'debugfs.ocfs2 -R
"logdump 0" /dev/replays/replay-data'.  We're looking for "Incompat:
0x2".  That means 64bit journals.

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
