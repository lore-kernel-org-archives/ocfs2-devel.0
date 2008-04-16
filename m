From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue, 15 Apr 2008 18:54:27 -0700
Subject: [Ocfs2-devel] dentry locks
Message-ID: <48055C53.9090809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any reason the dentry lock has parent# in string and block# in binary?

The reverse will make it easier to grep for dentry locks in tcpdumps.

Sunil
