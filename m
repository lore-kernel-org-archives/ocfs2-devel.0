From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jun 28 19:59:09 2004
Subject: [Ocfs2-devel] tree_depth
Message-ID: <20040629005906.GA1112@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As of revision 1200, ocfs2's tree_depth variables *start* at '0', instead of
the '-1' value we used to use before. Needless to say, zero is alot more
clear. Unfortunately this mean's you'll have to update tools and the module
and reformat yet again... sorry!  ;)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
