From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 15:59:53 +0800
Subject: [Ocfs2-devel] [PATCH 00/39] ocfs2: Add reflink file support. V3
Message-ID: <49F95A79.6040806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	So I have finally finished the v3 of reflink for ocfs2. The biggest 
change is that we support 64bit cluster offset now(Thank Mark and Joel 
for it).

[View]
http://oss.oracle.com/git/?p=tma/linux-2.6.git;a=shortlog;h=refcount
[Pull]
git://oss.oracle.com/git/tma/linux-2.6.git refcount

The general information for reflink, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/Reflink.

For the design doc, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/RefcountTrees
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkOperation
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkUses

The patch set is based on Joel's work of "ocfs2: Detach ocfs2 metadata
I/O from struct node" which can be found at
http://oss.oracle.com/pipermail/ocfs2-devel/2009-February/003926.html.

btw, some patches have ~1000 lines which make the review a little tough.
I will try to divide them into small parts in the next round. Please be 
patient.

Enjoy it.

Regards,
Tao
