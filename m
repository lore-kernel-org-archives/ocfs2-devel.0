From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Feb 2010 08:11:36 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize
 exceeds limit
In-Reply-To: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
References: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
Message-ID: <20100225161136.GB26801@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 25, 2010 at 10:00:59PM +0800, Wengang Wang wrote:
> This patch makes ocfs2 send SIGXFSZ if new file size exceeds limit.
> No suprise that processes get SIGXFSZ on one node(in the cluster) while they
> don't on another if file size limits are different on the two nodes.

	Why aren't you using inode_newsize_ok()?

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
