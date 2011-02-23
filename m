From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 13:21:12 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTik8xkLrc+WmRuikLroh4dANs5ikyk3x-QQFqgKS@mail.gmail.com>
References: <AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTik8xkLrc+WmRuikLroh4dANs5ikyk3x-QQFqgKS@mail.gmail.com>
Message-ID: <20110223212111.GI4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 03:09:22PM -0600, Goldwyn Rodrigues wrote:
> Are you sure that block_write_full_page_endio() will be called before
> the next system call on this file comes in and moves I_size beyond end
> of this page?

	Nope, and that's why I'm talking about things like fsync(), etc.
I'm pretty sure we're racing this sort of thing, because we should have
zeroed it ourselves.
	This comes back to block-based vs page-based zeroing.  The
kernel code should really handle blocks outside of our i_size (this is
what the block_write_full_page_endio() stuff is aimed for).  readpage,
writepage, etc just handle it.  However, the kernel is not responsible
for zeros in blocks we claim to be controlling, and it also doesn't
claim responsibility for blocks we're extending past.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

			http://www.jlbec.org/
			jlbec at evilplan.org
