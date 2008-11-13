From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 13 Nov 2008 14:53:36 -0800
Subject: [Ocfs2-devel] [PATCH 0/11] Dedicated metadata read functions
In-Reply-To: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
References: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20081113225336.GC15572@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 13, 2008 at 02:49:10PM -0800, Joel Becker wrote:
> The following patch series builds on top of the read_block cleanups to
> provide dedicated functions to read the various types of ocfs2 metadata.
> Rather than calling ocfs2_read_block[s]() directly, functions wanting an
> inode now call ocfs2_read_inode_block().  The same is true for extent
> blocks, group descriptors, and dirblocks.  I will get to xattr blocks
> later.

	Ack - xattr blocks are in this series now too.  See:

>       ocfs2: Wrap xattr block reads in a dedicated function

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
