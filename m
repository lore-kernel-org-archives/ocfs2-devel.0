From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 27 Jan 2010 18:59:38 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_dlmfs: Use poll() to signify BASTs.
In-Reply-To: <20100127221330.GA21942@mail.oracle.com>
References: <20100127221330.GA21942@mail.oracle.com>
Message-ID: <20100128025938.GC21942@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 27, 2010 at 02:13:31PM -0800, Joel Becker wrote:
> Because there is no asynchronous notification, there is no way for a
> process holding a lock to know another node needs the lock.  This is the
> number one complaint of ocfs2_dlmfs users.  Turns out, we can solve this
> very easily.  We add poll() support to ocfs2_dlmfs.  When a BAST is
> received, the lock's file descriptor will receive POLLIN.

	Here's a test program to drive this with raw filesystem access.
Start a heartbeat on each node, then run the test program on each node.
They should pass the lock around.

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: userdlm-polltest.c
Type: text/x-csrc
Size: 2383 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100127/8c23e90f/attachment.bin 
