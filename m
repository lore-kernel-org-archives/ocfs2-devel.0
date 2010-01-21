From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 21 Jan 2010 10:18:11 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <4B5749CF.6070004@oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<4B5749CF.6070004@oracle.com>
Message-ID: <20100121021811.GA3691@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-20 10:22, Sunil Mushran wrote:
> Wengang Wang wrote:
>> seems we need a noqueue version of the ocfs2_freeze_lock(). timeout it
>> after some retries.
>
> noqueue will not help. Launch a timer to fire off after 30 secs to do
> a cancel convert. If freeze succeeds before that, then cancel the timer.
>
>> that leads to the freeze operation last at lease 30 secs?
>
> No. It will wait for max 30 secs for the freeze operation to succeed.
> Once frozen, it will remain as is until thawed.

then you only meant the timer works for canceling ocfs2_freeze_lock()
for an EX. remember ocfs2_freeze_lock() is also called for a PR waiting
for thawing.

regards,
wengang
