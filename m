From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 03 Mar 2009 10:28:11 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V5)
In-Reply-To: <20090302215751.GC15068@mail.oracle.com>
References: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
	<20090228022236.GK10695@mail.oracle.com>
	<49AB4160.8050609@oracle.com>
	<20090302080846.GD29481@ca-server1.us.oracle.com>
	<49AB98C0.5070704@oracle.com>
	<20090302215751.GC15068@mail.oracle.com>
Message-ID: <49AC95BB.3000308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Mar 02, 2009 at 04:28:48PM +0800, Wengang Wang wrote:
>> Joel Becker wrote:
>>> 	Does this script reproduce the problem in the un-patched case?
>>> If so, and the patch fixes it, then we're good.
>> No, I never reproduced the bug on 1.4(did it only on 1.2 with adding  
>> sleep and force disk updating). but theoretically there is the problem  
>> on 1.4.
> 
> 	Oh, well.  I'd hope to have a reproduction case that would prove
> our solution.  

yes. I meant I tried but no luck.

That said, we have a good idea what was happening and the
> patch solves that.
> 	Please cook up the final patch so that Mark can queue it up.

will very soon.

regards,
wengang
