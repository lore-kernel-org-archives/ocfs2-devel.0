From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 20 Jan 2010 10:22:07 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100120045531.GA3794@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
Message-ID: <4B5749CF.6070004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> seems we need a noqueue version of the ocfs2_freeze_lock(). timeout it
> after some retries.

noqueue will not help. Launch a timer to fire off after 30 secs to do
a cancel convert. If freeze succeeds before that, then cancel the timer.

> that leads to the freeze operation last at lease 30 secs?

No. It will wait for max 30 secs for the freeze operation to succeed.
Once frozen, it will remain as is until thawed.
