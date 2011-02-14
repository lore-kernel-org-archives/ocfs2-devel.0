From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 14 Feb 2011 14:00:22 -0800
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
	<AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
Message-ID: <20110214220021.GB8413@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 12:24:01PM -0600, Goldwyn Rodrigues wrote:
> On Mon, Feb 14, 2011 at 1:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
> Why is zeroing to EOC a mistake?

	Because Linux writeback trims all writes to EOB for the block
surrounding i_size.  So when you fill pages to EOC, and blocksize !=
clustersize, you end up with pages that are never flushed to disk.
This becomes a problem.  In reflink CoW, it ends up being a BUG().
	See
http://kerneltrap.org/mailarchive/linux-kernel/2010/6/28/4587750 for the
entire discussion.  The final fix patches ended going in as:

a4bfb4c ocfs2: When zero extending, do it by page.
5693486 ocfs2: Zero the tail cluster when extending past i_size.
693c241 ocfs2: No need to zero pages past i_size.

> I ran my tests again and found the problem to be from EOB to
> End-of-cluster, and of course this happens only with
> blocksize<clustersize. So, in ocfs2_zero_extend rewriting zero_to_size
> to end-of-cluster works correctly  -

	I'm going to check out your test case, but please explain what
you think is broken.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

			http://www.jlbec.org/
			jlbec at evilplan.org
