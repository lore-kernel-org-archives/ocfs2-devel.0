From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 02 Mar 2009 16:28:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V5)
In-Reply-To: <20090302080846.GD29481@ca-server1.us.oracle.com>
References: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
	<20090228022236.GK10695@mail.oracle.com>
	<49AB4160.8050609@oracle.com>
	<20090302080846.GD29481@ca-server1.us.oracle.com>
Message-ID: <49AB98C0.5070704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Mar 02, 2009 at 10:16:00AM +0800, Wengang Wang wrote:
>>> 	Other than that, I think this patch is done!  Do you have a test
>>> to test it?
>> I tested against V4 which checks group without sub allocator cluster lock 
>> taken.
>> the test case is:
>> 1) 2 nodes env
>> 2) each node exports ocfs2 fs(/wwg-ocfs2_test).
>> 3) each node does the script:
> 
> 	Does this script reproduce the problem in the un-patched case?
> If so, and the patch fixes it, then we're good.

No, I never reproduced the bug on 1.4(did it only on 1.2 with adding 
sleep and force disk updating). but theoretically there is the problem 
on 1.4.

regards,
wengang.
