From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:11 +0800
Subject: [Ocfs2-devel] [PATCH 00/41] ocfs2: Add reflink file support. V4
Message-ID: <4A8A47DF.8020707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
     So I have finally finished the v4 of reflink for ocfs2. Great 
thanks for Joel's review.

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

The patch set is based on Joel's merge-window.

Enjoy it.

Regards,
Tao
