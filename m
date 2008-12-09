From: Nawaz, Nabil <nnawaz@epsilon.com>
Date: Tue, 09 Dec 2008 20:28:07 -0000
Subject: [Ocfs2-devel] Upgrade ocfs2 question?
Message-ID: <FFFC4A06BD14664BB93DB6AA31A7D02D42173F8661@TXMAILPROD.tx.epsilon.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 development team,

We are on RHEL5

oracle-umawachorad01-+ASM1:/u00/app/oracle/admin/wachprd/bdump> uname -a
Linux umawachorad01 2.6.18-92.el5 #1 SMP Tue Apr 29 13:16:15 EDT 2008 x86_64


We want to upgrade our current OCFS2 version 1.2.8 to the latest release 1.4.1

oracle-umawachorad01-+ASM1:/u00/app/oracle/admin/wachprd/bdump> cat /proc/fs/ocfs2/version
OCFS2 1.2.8 Wed May 21 20:46:51 PDT 2008 (build 9c7ae8bb50ef6d8791df2912775adcc5)

We would like the steps to do this. I presume we need to bring down our RAC lusterware and databases for this?

Thanks,
Nabil

________________________________
This e-mail and files transmitted with it are confidential, and are intended solely for the use of the individual or entity to whom this e-mail is addressed. If you are not the intended recipient, or the employee or agent responsible to deliver it to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you are not one of the named recipient(s) or otherwise have reason to believe that you received this message in error, please immediately notify sender by e-mail, and destroy the original message. Thank You.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081209/55ca1023/attachment-0001.html 
