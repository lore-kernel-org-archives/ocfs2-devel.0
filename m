From: David Binderman <dcb314@hotmail.com>
Date: Wed, 6 Apr 2016 18:23:02 +0000
Subject: [Ocfs2-devel] linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]: (style)
 Redundant condition
Message-ID: <DUB128-W561D1B4C5EA0D014C351739C9F0@phx.gbl>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello there,

linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]: (style) Redundant condition: eb. '!eb || (eb && !eb.h_next_leaf_blk)' is equivalent to '!eb || !eb.h_next_leaf_blk'

Source code is

??????? if (!eb || (eb && !eb->h_next_leaf_blk)) {

Also,

linux-4.6-rc2/fs/ocfs2/refcounttree.c:1011] -> [linux-4.6-rc2/fs/ocfs2/refcounttree.c:987]: (warning) Either the condition 'eb' is redundant or there is possible null pointer dereference: eb.


Regards

David Binderman

 		 	   		  
