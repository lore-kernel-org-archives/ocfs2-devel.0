From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 26 Feb 2010 15:12:45 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <20100223214728.GH31495@redhat.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
	<4B73155C.2000602@oracle.com> <20100210203527.GB5062@redhat.com>
	<20100223214728.GH31495@redhat.com>
Message-ID: <20100226231245.GE23730@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 23, 2010 at 01:47:28PM -0800, David Teigland wrote:
> The dlm is indeed sending the bast before the cast.  With the fix
> for that (attached), alternate is running fine again.  I'll now get
> back to doing some long running tests of make_panic and alternate.
> 
> I actually need to split up the fix into a couple different patches
> and will then queue them up for the coming merge window.

	I saw your pull request.  Is it safe to say ocfs2 + fs/dlm +
the bast/cast fixes now passes all your tests?

Joel

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
