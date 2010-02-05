From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 5 Feb 2010 15:30:16 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for	ocfs2 v6.
In-Reply-To: <20100205162739.GA25027@lst.de>
References: <1265363960-13329-1-git-send-email-tristan.ye@oracle.com>
	<1265363960-13329-2-git-send-email-tristan.ye@oracle.com>
	<20100205162739.GA25027@lst.de>
Message-ID: <20100205233016.GG3416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 05:27:39PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 05, 2010 at 05:59:20PM +0800, Tristan Ye wrote:
> I think you've totally overshoot the target here.  Just add a normal
> ioctls returning a structure with all interesting information without
> all that crap around it.  If it needs to be revisited it's trivial to
> just add another ioctl containing more fields.

	Related question: I notice that dvb has decided to use 'o' as
their ioctl letter as well.  Are we supposed to be trying to avoid their
_IOW('o', XX, ...) numbers, or can we just overlap?

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
