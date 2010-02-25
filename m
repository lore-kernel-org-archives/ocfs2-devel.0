From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 26 Feb 2010 00:29:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new
	filesize	exceeds limit
In-Reply-To: <20100225161136.GB26801@mail.oracle.com>
References: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
	<20100225161136.GB26801@mail.oracle.com>
Message-ID: <20100225162919.GA5118@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

Yes that I considered using inode_newsize_ok().
I'am not sure if checking i_size is safe(lack of knowledge).

regards,
wengang.
On 10-02-25 08:11, Joel Becker wrote:
> On Thu, Feb 25, 2010 at 10:00:59PM +0800, Wengang Wang wrote:
> > This patch makes ocfs2 send SIGXFSZ if new file size exceeds limit.
> > No suprise that processes get SIGXFSZ on one node(in the cluster) while they
> > don't on another if file size limits are different on the two nodes.
> 
> 	Why aren't you using inode_newsize_ok()?
> 
> Joel
