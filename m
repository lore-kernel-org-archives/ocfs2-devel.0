From: Tejun Heo <tj@kernel.org>
Date: Mon, 16 Aug 2010 10:03:32 +0200
Subject: [Ocfs2-devel] [PATCH] CMWQ: Set workqueue name before we
	process one work.
In-Reply-To: <4C68F0BA.5050905@oracle.com>
References: <1281944355-4379-1-git-send-email-tao.ma@oracle.com>
	<4C68EC76.70903@kernel.org> <4C68F0BA.5050905@oracle.com>
Message-ID: <4C68F0D4.7030300@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hello,

On 08/16/2010 10:03 AM, Tao Ma wrote:
>> I thought about the same thing but this doesn't provide any more
>> information than stack traces for debugging and for run time tracking
>> implementing tracing API (scheduled to be added in this devel cycle)
>> is the right approach.
>
> Do you have the link for this or it will show up in the mail list soon?

Oh, it's just on top of cmwq todo list.  fscache needs it too so it
will definitely happen sooner than later.  I'll try to remember to cc
eyou when I post patches.

Thanks.

-- 
tejun
