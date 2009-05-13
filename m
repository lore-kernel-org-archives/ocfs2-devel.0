From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 May 2009 11:57:10 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode()	call
In-Reply-To: <4A0B1529.6030701@telecom.by>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
	<20090513183924.GE32316@mail.oracle.com>
	<4A0B1529.6030701@telecom.by>
Message-ID: <20090513185710.GG32316@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 13, 2009 at 09:44:57PM +0300, Oleg Gawriloff wrote:
> Joel Becker ?????:
> > 	There's no other error messages?  Can you give us a larger
> > snippet of the log?
> Here:
> May 13 19:51:18 falcon-cl5
> May 13 19:51:18 falcon-cl5 (8824,2):ocfs2_read_locked_inode:466 ERROR: 
> status = -22

	This is really weird.  Like Sunil, I looked at the code.  And
every place that can set status to -EINVAL (-22) has its own ERROR
message.  So you should be seeing those.

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
