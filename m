From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 13 May 2009 12:08:36 -0700
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode() call
In-Reply-To: <20090513185710.GG32316@mail.oracle.com>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
	<20090513183924.GE32316@mail.oracle.com>
	<4A0B1529.6030701@telecom.by>
	<20090513185710.GG32316@mail.oracle.com>
Message-ID: <4A0B1AB4.40506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, May 13, 2009 at 09:44:57PM +0300, Oleg Gawriloff wrote:
>> Joel Becker ?????:
>>> 	There's no other error messages?  Can you give us a larger
>>> snippet of the log?
>> Here:
>> May 13 19:51:18 falcon-cl5
>> May 13 19:51:18 falcon-cl5 (8824,2):ocfs2_read_locked_inode:466 ERROR: 
>> status = -22
>
> 	This is really weird.  Like Sunil, I looked at the code.  And
> every place that can set status to -EINVAL (-22) has its own ERROR
> message.  So you should be seeing those.
>
> Joel

Exactly. Also, this could be related to that volume going read-only.
But if so, you will atleast see the following message:

        printk(KERN_CRIT "File system is now read-only due to the 
potential "
               "of on-disk corruption. Please run fsck.ocfs2 once the file "
               "system is unmounted.\n");

If the code is the same, then it could be that the difference is in the 
build.
But what, how, I cannot say.

BTW, maybe a good idea to fsck your volumes.

Sunil
