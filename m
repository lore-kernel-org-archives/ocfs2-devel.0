From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 27 Aug 2009 22:39:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <4A973D1D.70500@oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
	<4A973D1D.70500@oracle.com>
Message-ID: <20090828053911.GB19658@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 28, 2009 at 10:12:45AM +0800, Wengang Wang wrote:
> in fact, I had ever hit case that ocfs2 returns EIO, but even allowing 
> ENTRY/EXIT, there is no log indicating that.. the bug number is 8627756.
> 
> So I think we'd better add the logs to such functions. and added them 
> for the functions in aops.c(seems that Sunil wants to add logs to that 
> file)...

	Hunting down an -EIO is a good case, though we usually use
mlog_errno() for that.  The concern I have is not that you're logging,
it's that entry/exit are pretty poor things to log.
	For example, once you figure out where the -EIO is coming from,
I'd rather see us properly log that.

> and for the patch its self, I think the log contents are for developers 
> to check(not for customer to view), so we can know what are printed by 
> checking the src... so I am printing some parameters without pointing 
> out what they are.

	Yeah, I just don't know that we care :-)

Joel

-- 

Life's Little Instruction Book #157 

	"Take time to smell the roses."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
