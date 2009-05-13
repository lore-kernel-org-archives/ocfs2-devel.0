From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 May 2009 12:24:27 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode()	call
In-Reply-To: <4A0B1B81.8080908@oracle.com>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
	<20090513183924.GE32316@mail.oracle.com>
	<4A0B1529.6030701@telecom.by> <4A0B1B81.8080908@oracle.com>
Message-ID: <20090513192427.GH32316@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 13, 2009 at 12:12:01PM -0700, Sunil Mushran wrote:
> Oleg Gawriloff wrote:
> > May 13 21:35:55 falcon-cl5 (9369,5):ocfs2_begin_quota_recovery:374 
> > Beginning quota recovery in slot 2
> > May 13 21:35:55 falcon-cl5 (3127,2):ocfs2_finish_quota_recovery:564 
> > Finishing quota recovery in slot 2
> > May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
> > Finishing quota recovery in slot 2
> > May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
> > Finishing quota recovery in slot 2
> > May 13 21:35:57 falcon-cl5 o2net: connected to node falcon-cl1 (num 0) 
> > at 172.16.2.228:7777
> How did you enable quotas? While the fs has support for it, the tools don't.
> Meaning users cannot enable it using the tools as-is.

	I think the message is always there regardless.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
