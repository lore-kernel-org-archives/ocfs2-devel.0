From: jiangyiwen <jiangyiwen@huawei.com>
Date: Thu, 27 Aug 2015 20:11:21 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2: a method to prevent lock on the blocked
 queue is starved.
Message-ID: <55DEFE69.2060909@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_shuffle_lists, if there are conversions still blocked on the
converting queue all the time, the blocked locks on the blocked queue
can never be processed, so the locks on the blocked queue will be
starved.

So I have an idea to solve this problem: To switch the priority between
the converting queue and blocked queue, i.e. process the locks on the
blocked queue first. In this way, the lock on the blocked queue will
be processed and it will not enter the blocked queue until the
lockres is purged. so the scenario above will be solved.

Anyone has better ideas or advices?

Thanks,
Yiwen Jiang
