From: Andy <aryan1@allantgroup.com>
Date: Tue, 15 Apr 2014 16:36:34 -0500
Subject: [Ocfs2-devel] Caching free space information
Message-ID: <534DA662.9040101@allantgroup.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

	Does OCFS2 cache free space information?  The reason I am asking is 
that on several occasions when an OCFS2 filesystem hangs (for some 
reason), the df command will hang on a server which has the hung OCFS2 
filesystem mounted (NFS or local) when it tries to get free space 
information.  If the free space information were cached, then the server 
would just return the cached free space and not hang the df command.

Thanks,

Andy
