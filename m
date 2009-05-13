From: Oleg Gawriloff <barzog@telecom.by>
Date: Wed, 13 May 2009 20:09:08 +0300
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode() call
In-Reply-To: <4A0A084C.4040402@oracle.com>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
Message-ID: <4A0AFEB4.2080000@telecom.by>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran ?????:
> Oleg Gawriloff wrote:
>> After upgrading from 2.6.28.10 to 2.6.29.3 I've saw following new 
>> errors in kernel log:
>> May 12 14:46:41 falcon-cl5
>> May 12 14:46:41 falcon-cl5 (6757,7):ocfs2_read_locked_inode:466 ERROR: 
>> status = -22
> Did you modify the code? Apply some patches?
According to string number in kernel log I've see thats this block is in 
inode.c string 466:
         if (status < 0) {
                 mlog_errno(status);
                 goto bail;
         }
in ocfs2_read_locked_inode. How can we further investigate this issue?

btw one of 3 mounted ocfs2 filesystems goes to ro mode without obvious 
reason.
