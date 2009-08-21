From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 Aug 2009 00:10:00 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <4A8E0EAB.7070001@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-17-git-send-email-tao.ma@oracle.com>
	<20090821005932.GE10558@mail.oracle.com>
	<4A8E00A2.1050902@oracle.com>
	<20090821025136.GK10558@mail.oracle.com>
	<4A8E0EAB.7070001@oracle.com>
Message-ID: <20090821070959.GC20755@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 21, 2009 at 11:04:11AM +0800, Tao Ma wrote:
> oh, actually I drafted up this code in the hypothesis that write_len
> <= max_clusters, so if we want to write 1.5MB, I am afraid we need
> to rethink it carefully.

	While the write_begin code generally will honor your idea, I
think it's better for ocfs2_refcount_cow() to be able to handle
anything.  Then we can use it wherever.  For example, really large
extended attributes.

Joel

-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
