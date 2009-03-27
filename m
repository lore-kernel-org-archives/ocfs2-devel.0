From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 15:57:48 +0800
Subject: [Ocfs2-devel] [PATCH 00/42] ocfs2: Add reflink file support. V1
Message-ID: <49CC86FC.2070906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	So I have finally finished the v1 of reflink for ocfs2. It has some 
bugs that I am still investigating, but the schema is almost there. So 
I'd like to send it out first for review. And Tristan and I will 
continue to work on the stability of the code.

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
I will try to divide them into small parts in the next round. Sorry for 
the inconvenience.

Enjoy it.

Regards,
Tao
