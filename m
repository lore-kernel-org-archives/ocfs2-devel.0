From: Andi Kleen <ak@suse.de>
Date: 26 Apr 2006 06:11:04 +0200
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060425183553.GB10524@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
Message-ID: <p73odyp7z8n.fsf@bragg.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh <mark.fasheh@oracle.com> writes:
> 
> - We'd like as much of it to be user space code as is possible and
>   practical.

Won't you get into deadlocks then when the system is low on memory?
(freeing memory might require write outs on OCFS2 and the user space
cluster might be stuck already)

Or rather if you rely on user space you would need to make sure
that the basic block write out path works without such possible
deadlocks.

-Andi
