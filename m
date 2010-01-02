From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 2 Jan 2010 12:15:18 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JBD2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <F5F35C06-77A8-4902-908D-52BC2A052F44@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
	<20091231034243.GA2560@mail.oracle.com>
	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
	<4B3CF610.4070603@oracle.com>
	<6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
	<20091231200836.GA3301@mail.oracle.com>
	<F5F35C06-77A8-4902-908D-52BC2A052F44@wansecurity.com>
Message-ID: <20100102201517.GB9504@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 01, 2010 at 03:12:18PM +0900, Robert Smith wrote:
> I started a new kernel compile before I went to bed, and installed it this morning.
> 
> To my surprise, when the system booted up, it mounted the partition.

	Excellent!

> root at s2-replay02:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/replays-ReplayDataVolume001
>                        37T  1.3G   37T   1% /data/storage/ReplayDataVolume001
> 
> 1.3G for FS overhead. Partially due to the way I formatted I'm sure.

	Well, 1.3G out of 37T is like .003%.  I'm ok with that :-)

> 10485760000 bytes (10 GB) copied, 17.1197 s, 612 MB/s
> 104857600000 bytes (105 GB) copied, 176.464 s, 594 MB/s
> 1048576000000 bytes (1.0 TB) copied, 1825.52 s, 574 MB/s

	You've got some fast disk there ;-)

> Any other tests I can run to see how she's gonna hold up? What can I do to try to break it?

	Just use it as you normally would, I suspect.  The easy stuff
doesn't usually break.  It's often some behavior of some application.
	Thanks for trying this out and keeping us in the loop!

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
