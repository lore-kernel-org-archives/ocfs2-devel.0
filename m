From: Govardhanan Ramachandran <govardhanan.ramachandran@oracle.com>
Date: Fri, 08 Aug 2008 13:37:36 -0000
Subject: [Ocfs2-devel] OCFS2 Kernel for Xen Kernel 2.6.9-55.0.12.ELxenU
Message-ID: <20080808093741625.00000000192@goramach-us>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I am trying to install OCFS packages on my Oracle VM Guest (EL 4 update 5), whose original kernel was 2.6.9-55.0.0.2.ELxenU, but I upgraded it to 2.6.9-55.0.12.ELxenU because I could not get ASM lib loaded into the earlier version. But now, when I try to install OCFS package ocfs2-2.6.9-55.0.0.2.ELxen-1.2.9-1.el4.i686.rpm, it says that it requires 2.6.9-55.0.0.2.ELxenU as a prerequisite.

Is there a separate OCFS package, say, ocfs2-2.6.9-55.0.12.ELxen-1.2.9-1.el4.i686.rpm to go with my current kernel, i.e., 2.6.9-55.0.12.ELxenU, so that I can have the OCFS installed on my el4u5 VM guest? (Objective is to enable both ASM and OCFS on my Enterprise Linux 4.5 VM Guest).

Any suggestion for a resolution would greatly be appreciated. Thanks.

Regards,
Govardhanan.


Govardhanan Ramachandran | Principal Service Delivery Engineer | (734) 502-7365
Oracle USA Advanced Customer Services | High Availability & Mid-Tier Competency Engineering Team
Onsite for Hewlett-Packard @ General Motors
Desk at HP/GM: GM Warren Technical Center | Cube 2C8 | 7000 Chicago Road | Warren | MI ? 48092-1663
"Please consider your environmental responsibility before printing this e-mail"
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080808/4818b6cf/attachment-0001.html 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: oracle_sig_logo.gif
Type: image/gif
Size: 658 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080808/4818b6cf/attachment-0002.gif 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: env-resp.gif
Type: image/gif
Size: 1194 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080808/4818b6cf/attachment-0003.gif 
