From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Jul 2010 11:27:45 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: make xattr work with new local
 alloc reservation.
In-Reply-To: <4C1AE141.60707@oracle.com>
References: <4C1AE141.60707@oracle.com>
Message-ID: <20100708182745.GB17445@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 18, 2010 at 11:00:17AM +0800, Tao Ma wrote:
> 	The old xattr codes deem that we can allocate enough contiguous
> clusters from the allocator, it works with the old local alloc
> allocator. But as Mark has added reservation code to ocfs2, now it
> isn't the good hypothesis any more. So these 2 patches try to let
> xattr work with it.

	Am I right that the xattr code is broken without these?

Joel

-- 

"The whole principle is wrong; it's like demanding that grown men 
 live on skim milk because the baby can't eat steak."
        - author Robert A. Heinlein on censorship

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
