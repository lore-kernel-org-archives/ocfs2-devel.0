From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jun 14 16:20:16 2004
Subject: [Ocfs2-devel] File missing on another node
In-Reply-To: <B44D37711ED29844BEA67908EAF36F0315E080@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F0315E080@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040614211427.GL4380@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 14, 2004 at 02:17:10PM +0800, Chen, Yukun wrote:
> Hi all
> 
>    I meet a consistency issue. Steps to duplicate:
If you unmount all volumes, then remount one of them, how many files do you
see? Hopefully you'll see all 2000 in which case, something in our caching
might be broken (i've seen similar things myself, but have been too busy
with other code to track it down).
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
