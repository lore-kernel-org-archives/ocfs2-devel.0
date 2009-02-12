From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Feb 2009 14:17:40 -0800
Subject: [Ocfs2-devel] mount point is not unique among all nodes
In-Reply-To: <499481EF.40609@suse.de>
References: <499481EF.40609@suse.de>
Message-ID: <20090212221740.GB12965@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 13, 2009 at 04:09:19AM +0800, Coly Li wrote:
> Hi list,
> 
> Here is a bug report on novell bugzilla (https://bugzilla.novell.com/show_bug.cgi?id=456280) that
> mount point inside node A can be removed from node B.

	Can't access the bug.

> The problem is, node B does not know an empty dir is be using as mount point on another node. Is
> there any solution to return -EBUSY when a dir is be using as mount point on another node ?

	This is a good question.  As of right now, we don't have a way
to do it.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
