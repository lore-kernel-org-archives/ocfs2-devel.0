From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Oct 14 03:51:11 2005
Subject: [Ocfs2-devel] ocfs2's bmap output
In-Reply-To: <1129268016.8092.28.camel@localhost.localdomain>
References: <1129268016.8092.28.camel@localhost.localdomain>
Message-ID: <20051014085114.GP11488@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 14, 2005 at 01:33:35AM -0400, Shaya Potter wrote:
> I'm guessing this is because of its use of extents, and probably means
> I've screwed myself in trying to use bmap in this way.  Is that a
> correct assumption?  Is there any other interface into OCFS2 to tell if
> a block is a "blank" sparse area?

	OCFS2 does not support sparse files at this time.  So you'll
never find any holes, just allocated space.

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
