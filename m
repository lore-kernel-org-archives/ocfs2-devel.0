From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 13:37:31 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
References: <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
	<20110223211704.GH4020@noexit>
	<AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
Message-ID: <20110223213730.GK4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 03:35:36PM -0600, Goldwyn Rodrigues wrote:
> On Wed, Feb 23, 2011 at 3:17 PM, Joel Becker <jlbec@evilplan.org> wrote:
> >> 2. ?the previous write ended in a page boundary, but not a cluster
> >> boundary. eg, clustersize=16K but pos is at the page boundary = 4k
> >
> > ? ? ? ?Must it be a page boundary? ?What about a block boundary? ;-)
> 
> I am not sure of this, but I would like to stick with page boundary. I
> am too poor to afford a machine with a page size bigger than 4k to
> test this ;)

	Create a filesystem with 1K blocks and 16K clusters.  Now you
have four blocks per page, and you can test block vs page boundaries.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

			http://www.jlbec.org/
			jlbec at evilplan.org
