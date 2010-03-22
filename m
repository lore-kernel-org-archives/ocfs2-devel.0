From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 22 Mar 2010 13:41:59 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
 for directory data
In-Reply-To: <20100321232623.GN11402@wotan.suse.de>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
	<20100319224310.GF15539@mail.oracle.com>
	<20100320001425.GL11402@wotan.suse.de>
	<20100320012554.GI15539@mail.oracle.com>
	<20100320034758.GM11402@wotan.suse.de>
	<20100320061847.GA14324@mail.oracle.com>
	<20100321232623.GN11402@wotan.suse.de>
Message-ID: <20100322204158.GB14285@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Mar 21, 2010 at 04:26:23PM -0700, Mark Fasheh wrote:
> On Fri, Mar 19, 2010 at 11:18:48PM -0700, Joel Becker wrote:

> Aside from cleaning up the license info, I remove the dir_resv/no_dir_resv
> options. I also added a flags field to struct ocfs2_alloc_reservation which
> saves us the 'tmpwindow' argument to ocfs2_resmap_resv_bits().

	I like the changes.

> > 	I was thinking about a kernel tree untar where the directories
> > are holding on to reservations as thousands of files are created under
> > them.  Wouldn't that lead to cannibalization and show us that pattern?
> > This is just a lay guess - you have a lot more familiarity with the
> > code.
> 
> I don't know how much a kernel build is going to make a difference. I took a
> couple images after kernel builds with various options but didn't see
> anything obvious. To be fair though, I only checked one or two files. I'll
> upload the images somewhere shortly.
> 
> As an interim compromise, I changed the code to get minimum (8 bits) sized
> windows on directories. That way, they'll get some amount of
> continguousness, but not as much as file data. We can easily adjust in any
> direction we want.

	I wonder how the varying reservation sizes will impact
ulilization of the localalloc.  May not matter, but there's a part of me
that wonders.  Does the new dir-resv code do as well on your tests as
the no-dir-resv code?
	Maybe something to see any help from dir reservations would be a
many-parallel-untar sort of thing?  Unpack 20 kernel trees at the same
time?  Some other package with a lot of files.  I have no idea if this
will mean anything, and I actually rather trust your observations of
previous untars.  I'm just casting about for something to show us how
dir reservations are behaving.

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
