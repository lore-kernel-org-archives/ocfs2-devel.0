From: David Teigland <teigland@redhat.com>
Date: Tue, 2 Mar 2010 20:54:53 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <20100226231245.GE23730@mail.oracle.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
	<4B73155C.2000602@oracle.com> <20100210203527.GB5062@redhat.com>
	<20100223214728.GH31495@redhat.com>
	<20100226231245.GE23730@mail.oracle.com>
Message-ID: <20100303025453.GB14209@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 03:12:45PM -0800, Joel Becker wrote:
> On Tue, Feb 23, 2010 at 01:47:28PM -0800, David Teigland wrote:
> > The dlm is indeed sending the bast before the cast.  With the fix
> > for that (attached), alternate is running fine again.  I'll now get
> > back to doing some long running tests of make_panic and alternate.
> > 
> > I actually need to split up the fix into a couple different patches
> > and will then queue them up for the coming merge window.
> 
> 	I saw your pull request.  Is it safe to say ocfs2 + fs/dlm +
> the bast/cast fixes now passes all your tests?

It's much improved, but I still seem to get one wrong or missing bast
eventually.  I'll dig back into that in a couple weeks.  My hunch is that
it's related to a lock being canceled.
Dave
