From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 28 Jan 2010 02:14:29 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <4B5749CF.6070004@oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<4B5749CF.6070004@oracle.com>
Message-ID: <20100127181429.GA4635@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,

On 10-01-20 10:22, Sunil Mushran wrote:
> Wengang Wang wrote:
>> seems we need a noqueue version of the ocfs2_freeze_lock(). timeout it
>> after some retries.
>
> noqueue will not help. Launch a timer to fire off after 30 secs to do
> a cancel convert. If freeze succeeds before that, then cancel the timer.

I think the timer is not a very good idea. Canceling an ocfs2 cluster
lock is not complex though it needs lines of code changes. 
By your word, I felt you are meaning that the timer is a separated thing
from ocfs2_cluster_lock(). If so, we have to ensure the ocfs2_cluster_lock()
is really issued before the timer acts. Though here 30s is good that but are
we sure that it must be enough at any case? --I think we aren't.
Making sure cluster lock is issued before the timer acts, I guess we
need more code change and I think that is not worthy --it introduces bugs
and it's only for freeze/thaw, not a common demand.

So to avoid very long time waiting of a mount when cluster is frozen, I
want it make tries of no-queue cluster lock. And so does it when acquiring EX.

regards,
wengang.
