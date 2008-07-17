From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Jul 2008 14:20:38 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates for
	2.6.27
In-Reply-To: <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
References: <20080717175146.GH28014@wotan.suse.de>
	<alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
Message-ID: <20080717212038.GA8283@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jul 17, 2008 at 11:01:40AM -0700, Linus Torvalds wrote:
> .. I really dislike how this was done.

	Argh!

> This commit:
> 
> 11c3b79218390a139f2d474ee1e983a672d5839a ("configfs: Allow ->make_item() 
> and ->make_group() to return detailed errors.")
> 
> is just ugly. Returning one value by passing a pointer to a pointer, and 
> the error value by returning an 'int' errno is _not_ how we do things in 
> the kernel.

	See, I coded it up with PTR_ERR() first, and everyone I showed
it to said "I hate PTR_ERR()!".

> I pulled it, but I want to register my protest.

	I wish you hadn't, because it won't be to difficult to go back
to PTR_ERR().  However, don't revert it - that affects some of the
follow-on patches that were affected by the change.
	I'll spin up a new PTR_ERR() change.  I have some more cleanups
coming too, they need to finish their time in linux-next.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
