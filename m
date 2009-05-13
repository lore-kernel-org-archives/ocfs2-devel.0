From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 May 2009 11:39:24 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode()	call
In-Reply-To: <4A0AFEB4.2080000@telecom.by>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
Message-ID: <20090513183924.GE32316@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 13, 2009 at 08:09:08PM +0300, Oleg Gawriloff wrote:
> Sunil Mushran ?????:
> > Oleg Gawriloff wrote:
> >> After upgrading from 2.6.28.10 to 2.6.29.3 I've saw following new 
> >> errors in kernel log:
> >> May 12 14:46:41 falcon-cl5
> >> May 12 14:46:41 falcon-cl5 (6757,7):ocfs2_read_locked_inode:466 ERROR: 
> >> status = -22
> > Did you modify the code? Apply some patches?
> According to string number in kernel log I've see thats this block is in 
> inode.c string 466:
>          if (status < 0) {
>                  mlog_errno(status);
>                  goto bail;
>          }
> in ocfs2_read_locked_inode. How can we further investigate this issue?
> 
> btw one of 3 mounted ocfs2 filesystems goes to ro mode without obvious 
> reason.

	There's no other error messages?  Can you give us a larger
snippet of the log?

Joel
-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
