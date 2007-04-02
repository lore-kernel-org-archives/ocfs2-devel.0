From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Apr  2 16:55:28 2007
Subject: [Ocfs2-devel] [PATCH 0/3] Properly protect the extent map
In-Reply-To: <20070402184713.GB21982@ca-server1.us.oracle.com>
References: <20070329005041.518030000@oracle.com>
	<20070402184713.GB21982@ca-server1.us.oracle.com>
Message-ID: <20070402235524.GB4757@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 02, 2007 at 11:47:13AM -0700, Mark Fasheh wrote:
> On Wed, Mar 28, 2007 at 06:27:07PM -0700, Joel Becker wrote:
> > The patches that follow are against mainline.  They have been tested
> > against 1.2 with local mounts.
> > 
> > Patches (1) and (2) will be ported to the ocfs2 1.2 branch directly,
> > and all three fixes will be pushed to mainline.
> 
> Ok. These patches look good - thanks. Have you had a chance to test against
> mainline?

	I haven't yet, only Fabionne has.  I will tomorrow.

Joel

-- 

"We'd better get back, `cause it'll be dark soon,
 and they mostly come at night.  Mostly."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
