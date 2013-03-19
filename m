From: admin at wset.edu.pl <admin@wset.edu.pl>
Date: Tue, 19 Mar 2013 10:02:43 +0100
Subject: [Ocfs2-devel] OEL 6.4 + OCFS 1.8 - This same bugs like in old 1.6
	and Vanilla kernels [ 3.2.40 including ]
Message-ID: <FAD1D0B76E0B47DF8196B6FCEA20EF7D@tktelekom.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello
I just install fresh OEL 6.4 to check how working OCFS 1.8 and i saw there is still bug with spam error messages in dmesg like in 1.6.

[root at OCFS2-1 ~]# uname -a
Linux OCFS2-1.tktelekom.pl 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux

[root at OCFS2-1 ~]# dmesg
[cut]
(rm,2362,0):ocfs2_unlink:951 ERROR: status = -2
(rm,2527,1):ocfs2_unlink:951 ERROR: status = ?39

Thanks
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130319/c0847486/attachment.html 
