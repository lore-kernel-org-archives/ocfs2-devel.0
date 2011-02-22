From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 13:39:28 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
Message-ID: <20110222213927.GA28774@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 01:02:13PM -0600, Goldwyn Rodrigues wrote:
> On Tue, Feb 22, 2011 at 2:36 AM, Joel Becker <jlbec@evilplan.org> wrote:
> > ? ? ? ?Please try the attached patch and see if it fixes the problem.
> > It should work on its own, without your changes. ?If I have it wrong,
> > we'll continue to evaluate the problem. ?I'd test it myself, but my VM
> > setup is currently broken.
> >
> 
> It does not work. However, it shows the behavior similar to "nosparse"
> without patch. So, I would say what you are targeting is achieved but
> another problem resurfaces. This is because nothing zeros pages beyond
> i_size in ocfs2_map_page_blocks(), since we return early because of -
> 
>         if (ret == 0 || !new)
>                 return ret;

	Returning here is correct, because ret should == 0.  The new
part is about zeroing in the case of error.  We should obviously handle
it better before we get to this line.
	I like that we come in line nosparse and sparse.  What does
tailtest do for you?  Does it fail or succeed?

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

			http://www.jlbec.org/
			jlbec at evilplan.org
