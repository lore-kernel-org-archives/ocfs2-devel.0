From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 19 Sep 2008 17:35:22 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: add security EA and ACL support v1
Message-ID: <48D3725A.1030701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
The previous patches about EA didn't implement POSIX ACL and security 
EA. I add those support here.

The first patch fix some problem in xattr code.
The second patch add security EA support.
The third patch add ACL support basically.

Best regards,
tiger
