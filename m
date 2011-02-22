From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 01:37:41 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110222083648.GC30966@noexit>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
Message-ID: <20110222093740.GI30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 12:36:49AM -0800, Joel Becker wrote:
> 	Please try the attached patch and see if it fixes the problem.
> It should work on its own, without your changes.  If I have it wrong,
> we'll continue to evaluate the problem.  I'd test it myself, but my VM
> setup is currently broken.

	Also, can someone run tailtest out of ocfs2-test against it.  I
want to make sure I didn't break anything else.  Grr on broken test
setup.  I'm also sad that tailtest didn't catch Goldwyn's case.  I
wonder if we can make it.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

			http://www.jlbec.org/
			jlbec at evilplan.org
