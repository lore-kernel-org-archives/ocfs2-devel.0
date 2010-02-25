From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Feb 2010 12:01:53 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize
 exceeds limit
In-Reply-To: <20100225162919.GA5118@laptop.oracle.com>
References: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
	<20100225161136.GB26801@mail.oracle.com>
	<20100225162919.GA5118@laptop.oracle.com>
Message-ID: <20100225200153.GC26801@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 12:29:19AM +0800, Wengang Wang wrote:
> Yes that I considered using inode_newsize_ok().
> I'am not sure if checking i_size is safe(lack of knowledge).

	It should be, given that i_mutex is held.  Filesystems that
don't handle their own setattr get to inode_newsize_ok() via
vmtruncate.

Joel


-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
