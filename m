From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Aug 19 21:39:36 2004
Subject: [Ocfs2-devel] LTP system call test all pass!
In-Reply-To: <20040820023128.GR2098@ca-server1.us.oracle.com>
References: <3ACA40606221794F80A5670F0AF15F84053D990A@pdsmsx403>
	<20040820021931.GQ2098@ca-server1.us.oracle.com>
	<20040820023128.GR2098@ca-server1.us.oracle.com>
Message-ID: <20040820023932.GS2098@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 19, 2004 at 07:31:28PM -0700, Joel Becker wrote:
> 	I just created a file on ocfs2, ran mkfs.ext3, and mounted it
> with loopback ("mount -o loop /ocfs2/loopme /mnt/tmp").  It worked fine.
> If you have any problems, let us know.

	Yosh tells me that the problem is creating an OCFS2 on the
loopback, not creating a loopback file on an OCFS2.  Well, I tried the
other ("losetup /dev/loop0 /tmp/loopme; mkfs.ocfs2 /dev/loop0; mount
/dev/loop0") and it worked fine as well.

Joel
-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
