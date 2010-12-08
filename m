From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 8 Dec 2010 10:12:23 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: make existing convertion
 precedent over new lock
In-Reply-To: <20101208180757.GC21913@mail.oracle.com>
References: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>
	<20101208180757.GC21913@mail.oracle.com>
Message-ID: <20101208181222.GD21913@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 08, 2010 at 10:07:57AM -0800, Joel Becker wrote:
> On Wed, Dec 08, 2010 at 08:34:39PM +0800, Wengang Wang wrote:
> > Make existing convertion precedent over new lock. It makes o2dlm locking more
> > like fair locking.
> 
> 	Is this a problem you were solving, or just something you
> thought about while reading the code?  If it was a problem you ran
> into, can you give the details?

	It looks like you're just emulating the logic from
__dlmconvert_master().  That makes sense.

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
