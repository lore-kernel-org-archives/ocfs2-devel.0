From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 5 Feb 2010 11:26:21 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for	ocfs2 v6.
In-Reply-To: <20100205162739.GA25027@lst.de>
References: <1265363960-13329-1-git-send-email-tristan.ye@oracle.com>
	<1265363960-13329-2-git-send-email-tristan.ye@oracle.com>
	<20100205162739.GA25027@lst.de>
Message-ID: <20100205192621.GB3416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 05:27:39PM +0100, Christoph Hellwig wrote:
> I think you've totally overshoot the target here.  Just add a normal
> ioctls returning a structure with all interesting information without
> all that crap around it.  If it needs to be revisited it's trivial to
> just add another ioctl containing more fields.

	There's going to be 10 or more request, and growing as we want to
add things.  I'm to blame for the above idea, because I'd rather pass in
an array of 10+ requests than have 10+ individual calls.

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
