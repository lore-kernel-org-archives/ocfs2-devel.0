From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 9 Jul 2010 01:01:34 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: make xattr extension work with new
 local alloc reservation.
In-Reply-To: <4C3699B9.3010204@oracle.com>
References: <4C1AE141.60707@oracle.com>
	<1276830171-5908-1-git-send-email-tao.ma@oracle.com>
	<20100708185134.GD17445@mail.oracle.com>
	<4C3699B9.3010204@oracle.com>
Message-ID: <20100709080133.GA6398@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 09, 2010 at 11:38:33AM +0800, Tao Ma wrote:
> But I just have one concern: should I add stable to cc list the
> first time I create the patch? I am afraid not since it may be
> changed may times and have many revisions.

	You can add it before the final pull request.  You don't need to
add my ack - I'll have signed off on the way through my tree.  I always
use --suppress-cc=all on git-send-email, so I never worry about this ;-)

Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
