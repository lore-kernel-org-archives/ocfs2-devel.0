From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 2 Jan 2010 12:19:14 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <7DDC187D-D7DB-4640-91D7-92F7CF5CA704@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
	<20091231034243.GA2560@mail.oracle.com>
	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
	<4B3CF610.4070603@oracle.com>
	<6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
	<20091231200836.GA3301@mail.oracle.com>
	<7DDC187D-D7DB-4640-91D7-92F7CF5CA704@wansecurity.com>
Message-ID: <20100102201914.GC9504@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jan 02, 2010 at 04:47:58AM +0900, Robert Smith wrote:
> Just thought I would let you guys know that creating a 20TB file was successful. I even appended data to the end of it. Any operations on the file are completely useless because they take way to long. A appended "hello" to the end of the file no problem, but tail -n 1 {filename} yielded nothing except a lot of disk read after 159minutes of waiting.

	Wow, that's a lot of waiting.  I suspect it's the fault of
tail(1).  You asked for the last line of the file (tail -1).  I bet
tail(1) is reading the entire file line-by-line in order to calculate
the last line.  This has to be much slower than reading it at optimal
hunks (with your 500MB/s disks).  Conversely, appending is easy because
the kernel just starts at the end of the file.  No need to read the
existing 20TB.
	What other operations are 'completely useless'?  The expectation
would be that random I/O is as fast as ever.  How long does deleting
take?

Joel

-- 

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
