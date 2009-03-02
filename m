From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 2 Mar 2009 00:08:46 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V5)
In-Reply-To: <49AB4160.8050609@oracle.com>
References: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
	<20090228022236.GK10695@mail.oracle.com>
	<49AB4160.8050609@oracle.com>
Message-ID: <20090302080846.GD29481@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 02, 2009 at 10:16:00AM +0800, Wengang Wang wrote:
>> 	Other than that, I think this patch is done!  Do you have a test
>> to test it?
>
> I tested against V4 which checks group without sub allocator cluster lock 
> taken.
> the test case is:
> 1) 2 nodes env
> 2) each node exports ocfs2 fs(/wwg-ocfs2_test).
> 3) each node does the script:

	Does this script reproduce the problem in the un-patched case?
If so, and the patch fixes it, then we're good.

Joel

-- 

"And yet I find,
 And yet I find repeating in my head.
 If I can't be my own, 
 I'd feel better dead."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
