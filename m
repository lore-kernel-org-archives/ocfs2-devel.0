From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 13:23:20 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTinkyJa0m230Pyu=PdQRsDL62FSXLmTeGYO_s2hN@mail.gmail.com>
References: <20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit> <20110223192826.GB4020@noexit>
	<AANLkTinkyJa0m230Pyu=PdQRsDL62FSXLmTeGYO_s2hN@mail.gmail.com>
Message-ID: <20110223212320.GJ4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 03:00:58PM -0600, Goldwyn Rodrigues wrote:
> On Wed, Feb 23, 2011 at 1:28 PM, Joel Becker <jlbec@evilplan.org> wrote:
> > On Wed, Feb 23, 2011 at 11:13:39AM -0800, Joel Becker wrote:
> >> The calling code should have made sure we are correctly passing
> >> should_zero to all non-target pages. ?Having new overridden for them is
> >> wrong. ?So maybe we move your check inside the target_page if. ?It only
> >> really matters for the target page.
> >
> > ? ? ? ?Actually, I have a question: what is the clustersize of your
> > test? ?Because if the filesystem is 4k/4k, the write at 4096 of 32 bytes
> > should allocate a new cluster. ?'new' should already be set, and your
> > check irrelevant.
> 
> It is 16K and does not happen for clustersize==pagesize/blocksize.
> Don't have a machine with a bigger pagesize handy.

	That's what I expected.

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

			http://www.jlbec.org/
			jlbec at evilplan.org
