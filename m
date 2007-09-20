From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 16:40:08 2007
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: Write support for inline data
In-Reply-To: <200709192012.l8JKCHat012235@agmgw2.us.oracle.com>
References: <200709192012.l8JKCHat012235@agmgw2.us.oracle.com>
Message-ID: <20070920233926.GE3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 07, 2007 at 02:46:51PM -0700, Mark Fasheh wrote:
> This fixes up write, truncate, mmap, and RESVSP/UNRESVP to understand inline
> inode data.
> 
> For the most part, the changes to the core write code can be relied on to do
> the heavy lifting. Any code calling ocfs2_write_begin (including shared
> writeable mmap) can count on it doing the right thing with respect to
> growing inline data to an extent tree.
> 
> Size reducing truncates, including UNRESVP can simply zero that portion of
> the inode block being removed. Size increasing truncatesm, including RESVP
> have to be a little bit smarter and grow the inode to an extent tree if
> necessary.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

None of our men are "experts."  We have most unfortunately found
it necessary to get rid of a man as soon as he thinks himself an
expert -- because no one ever considers himself expert if he really
knows his job.  A man who knows a job sees so much more to be done
than he has done, that he is always pressing forward and never
gives up an instant of thought to how good and how efficient he is.
Thinking always ahead, thinking always of trying to do more, brings
a state of mind in which nothing is impossible. The moment one gets
into the "expert" state of mind a great number of things become
impossible.
	- From Henry Ford Sr., "My Life and Work"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
