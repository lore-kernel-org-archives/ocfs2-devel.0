From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 25 Sep 2015 09:53:36 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2: a method to prevent lock on the
 blocked queue is starved.
In-Reply-To: <55DEFE69.2060909@huawei.com>
References: <55DEFE69.2060909@huawei.com>
Message-ID: <5604A920.3040200@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Simply switch converting list and blocked list cannot resolve the
starvation case fundamentally.
Maybe we have to set a deadline and bring in a scheduler strategy.
@Junxiao, do you have any other idea?

On 2015/8/27 20:11, jiangyiwen wrote:
> In dlm_shuffle_lists, if there are conversions still blocked on the
> converting queue all the time, the blocked locks on the blocked queue
> can never be processed, so the locks on the blocked queue will be
> starved.
> 
> So I have an idea to solve this problem: To switch the priority between
> the converting queue and blocked queue, i.e. process the locks on the
> blocked queue first. In this way, the lock on the blocked queue will
> be processed and it will not enter the blocked queue until the
> lockres is purged. so the scenario above will be solved.
> 
> Anyone has better ideas or advices?
> 
> Thanks,
> Yiwen Jiang
> 
> 
> .
> 
