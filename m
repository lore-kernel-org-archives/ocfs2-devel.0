From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 26 Feb 2010 10:18:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new
	filesize	exceeds limit
In-Reply-To: <20100225200153.GC26801@mail.oracle.com>
References: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
	<20100225161136.GB26801@mail.oracle.com>
	<20100225162919.GA5118@laptop.oracle.com>
	<20100225200153.GC26801@mail.oracle.com>
Message-ID: <20100226021813.GA3336@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

On 10-02-25 12:01, Joel Becker wrote:
> On Fri, Feb 26, 2010 at 12:29:19AM +0800, Wengang Wang wrote:
> > Yes that I considered using inode_newsize_ok().
> > I'am not sure if checking i_size is safe(lack of knowledge).
> 
> 	It should be, given that i_mutex is held.  Filesystems that
> don't handle their own setattr get to inode_newsize_ok() via
> vmtruncate.

What if this case:
0) there is a file with size 4k.
1) user sets file max size to 1k.
2) user resize the 4k-size file to 2k.

If we go with inode_newsize_ok(), the operation succeeds. But doesn't it
disobey the file size limit?
I didn't find a explicit description for that case. But I prefer that
step 2) fails.

regards,
wengang.
