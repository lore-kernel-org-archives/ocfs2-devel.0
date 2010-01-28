From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 28 Jan 2010 10:08:56 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100128130014.GA4083@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<4B5749CF.6070004@oracle.com>
	<20100127181429.GA4635@laptop.oracle.com>
	<4B609D5E.5080404@oracle.com>
	<20100128130014.GA4083@laptop.oracle.com>
Message-ID: <4B61D2B8.9030807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> cancel convert for what? only the freeze lock or a command interface for
> all cluster lock?
> I don't know if it's needed for a commond cluster lock. But anyway,
> seems the freeze/thaw relies on a cancelable(or a timeout version of) cluster
> lock. Otherwise, the lock will wait for thaw for ever. If there is a umount at
> the time, ocfs2 cleaning up hangs(at flushing work queue). Yes maybe we have a
> way to postpone the umount if we are aquiring the PR lock, but that also
> means if the cluster is frozen, umount has to wait until cluster thawed(this
> is bad).
>
> So, if we have plan to implement cancelable cluster lock(or a timeout version of
> cluster lock). I think we'd better do that before supporting freeze/thaw.

No. Please ignore the timer bit for now. Implement the rest first.
We'll get to this later.
