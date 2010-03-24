From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 23 Mar 2010 19:13:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <4BA96675.80506@oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
	<20100323195224.GA31783@mail.oracle.com>
	<4BA96675.80506@oracle.com>
Message-ID: <20100324021306.GH31783@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 24, 2010 at 09:10:13AM +0800, tristan wrote:
> Joel Becker wrote:
> > On Tue, Mar 23, 2010 at 04:04:44PM +0800, Tristan Ye wrote:
> >> Fast symlink can be treated the same way as inline file for truncating
> >> and hole punching, since the mechanism is quite simliar per se.
> >>
> >> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> >
> > 	The patch looks good, with perhaps a bit over-zealous
> > parentheses ;-)  Is this fixing a bug someone has hit?
> 
> Not exactly,
> 
> Sunil reported such a bug from userspace in libocfs2, I suddenly 
> realised that we could also do the same in fs.

	The difference is that we never call the truncate code for fast
symlinks or inline data in the kernel.  We do in libocfs2.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
