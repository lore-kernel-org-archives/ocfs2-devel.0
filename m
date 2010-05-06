From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 5 May 2010 18:05:04 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <1272284243-22492-1-git-send-email-tristan.ye@oracle.com>
References: <1272284243-22492-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100506010503.GA9955@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 26, 2010 at 08:17:23PM +0800, Tristan Ye wrote:
> The reason why we need this ioctl is to offer the none-privileged
> end-user a possibility to get filesys info gathering.
> 
> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
> structure to kernel containing an array of request pointers and request
> count, such as,

	You're going to hate us, but Sunil and I decided that the
complex error reporting was just too much for what should be a simple
query interface.  We think we should go back to the original, where any
error is returned, and the caller cannot trust any of the results unless
the call returns 0.  This means you don't need the ir_error field.  I
suppose you can keep the ERROR flag, as this can tell the caller which
request caused the error.

Joel

-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
