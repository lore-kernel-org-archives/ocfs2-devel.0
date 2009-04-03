From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 03 Apr 2009 16:37:22 +0800
Subject: [Ocfs2-devel] [PATCH 00/42] ocfs2: Add reflink file support. V2
Message-ID: <49D5CAC2.4010201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	Change from v1 to v2: bug fix and metadata/credits reservation 
improvement.

The general information for reflink, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/Reflink.

For the design doc, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/RefcountTrees
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkOperation
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkUses

The patch set is based on Joel's work of "ocfs2: Detach ocfs2 metadata
I/O from struct node" which can be found at
http://oss.oracle.com/pipermail/ocfs2-devel/2009-February/003926.html.

Enjoy it.

Regards,
Tao
