From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Feb 2010 21:55:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize
 exceeds limit
In-Reply-To: <20100226021813.GA3336@laptop.oracle.com>
References: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
	<20100225161136.GB26801@mail.oracle.com>
	<20100225162919.GA5118@laptop.oracle.com>
	<20100225200153.GC26801@mail.oracle.com>
	<20100226021813.GA3336@laptop.oracle.com>
Message-ID: <20100226055548.GB26343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 10:18:13AM +0800, Wengang Wang wrote:
> On 10-02-25 12:01, Joel Becker wrote:
> > On Fri, Feb 26, 2010 at 12:29:19AM +0800, Wengang Wang wrote:
> > > Yes that I considered using inode_newsize_ok().
> > > I'am not sure if checking i_size is safe(lack of knowledge).
> > 
> > 	It should be, given that i_mutex is held.  Filesystems that
> > don't handle their own setattr get to inode_newsize_ok() via
> > vmtruncate.
> 
> What if this case:
> 0) there is a file with size 4k.
> 1) user sets file max size to 1k.
> 2) user resize the 4k-size file to 2k.
> 
> If we go with inode_newsize_ok(), the operation succeeds. But doesn't it
> disobey the file size limit?
> I didn't find a explicit description for that case. But I prefer that
> step 2) fails.

	It was already larger.  You haven't broken anything.  I don't
know exactly what POSIX says, but since inode_newsize_ok() is the
behavior used by most or all other Linux filesystems, we should be
consistent unless we're sure POSIX disagrees.
	Wikipedia states that SIGXFSZ is only triggered when a process
causes a file to *grow* past the limit.  It doesn't mention shrinking.
Use inode_newsize_ok().

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
