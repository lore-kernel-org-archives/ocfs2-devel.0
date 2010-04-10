From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 10 Apr 2010 02:37:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
Message-ID: <20100410093717.GA19607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Apr 10, 2010 at 01:37:58AM -0600, Dong Yang Li wrote:
> I still get a bug with this check and without my patch:
> 
> 
> [16179.955148] (13400,1):ocfs2_truncate_file:465 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
> [16179.955157] (13400,1):ocfs2_truncate_file:465 ERROR: Inode 254789, inode i_size = 811008 != di i_size = 809011, i_flags = 0x1
> the call trace is the same.

	What's the testcase?

Joel

-- 

	f/8 and be there.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
