From: admin at wset.edu.pl <admin@wset.edu.pl>
Date: Tue, 19 Mar 2013 10:38:08 +0100
Subject: [Ocfs2-devel] OEL 6.4 + OCFS 1.8 - This same bugs like in old
	1.6and Vanilla kernels [ 3.2.40 including ]
In-Reply-To: <FAD1D0B76E0B47DF8196B6FCEA20EF7D@tktelekom.net>
References: <FAD1D0B76E0B47DF8196B6FCEA20EF7D@tktelekom.net>
Message-ID: <8559D8CB453B48549C1F80A7E405A159@tktelekom.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

And after 30 minutes i get kernel panic too but can`t log oops because i this is  vmware clouster 


From: admin@wset.edu.pl 
Sent: Tuesday, March 19, 2013 10:02 AM
To: ocfs2-users at oss.oracle.com ; ocfs2-devel at oss.oracle.com 
Subject: [Ocfs2-devel] OEL 6.4 + OCFS 1.8 - This same bugs like in old 1.6and Vanilla kernels [ 3.2.40 including ]

Hello
I just install fresh OEL 6.4 to check how working OCFS 1.8 and i saw there is still bug with spam error messages in dmesg like in 1.6.

[root at OCFS2-1 ~]# uname -a
Linux OCFS2-1.tktelekom.pl 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux

[root at OCFS2-1 ~]# dmesg
[cut]
(rm,2362,0):ocfs2_unlink:951 ERROR: status = -2
(rm,2527,1):ocfs2_unlink:951 ERROR: status = ?39

Thanks



--------------------------------------------------------------------------------
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130319/fb8db3ee/attachment.html 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: image/png
Size: 1090 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130319/fb8db3ee/attachment.png 
