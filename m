From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Dec  5 20:45:55 2006
Subject: [Ocfs2-devel] [patch 3/3] ocfs2-timeout-protocol.patch
In-Reply-To: <4574B668.4000808@oracle.com>
References: <20061204130452.199246000@suse.de>
	<20061204131237.894581000@suse.de> <4574B668.4000808@oracle.com>
Message-ID: <20061206044551.GC4497@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 04, 2006 at 03:59:36PM -0800, Zach Brown wrote:
> It occurs to me that this probably doesn't catch all cases.  Imagine
> old_sc and sc both being non-null.  It'd dec when it shouldn't change.
I made the change myself and merged the patch series into ocfs2.git.

Thanks, Andrew.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
