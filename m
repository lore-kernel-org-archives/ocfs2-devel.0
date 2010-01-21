From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 20 Jan 2010 18:32:05 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100121021811.GA3691@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<4B5749CF.6070004@oracle.com>
	<20100121021811.GA3691@laptop.oracle.com>
Message-ID: <4B57BCA5.5070305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> then you only meant the timer works for canceling ocfs2_freeze_lock()
> for an EX. remember ocfs2_freeze_lock() is also called for a PR waiting
> for thawing.

Yes. Only for EX because that's what the node issuing the freeze
command takes.
