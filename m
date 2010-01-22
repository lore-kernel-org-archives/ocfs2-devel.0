From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 22 Jan 2010 12:22:14 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100120045531.GA3794@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
Message-ID: <20100122042214.GA3797@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

> >> Though we don't support it, we hope to make the operation succeed.
> >> the big pain is the we have no way to know if a nested freeze is done
> >> againt ocfs2 volume. the second freeze doesn't come to ocfs2, it returns
> >> by vfs(in freeze_bdev()). so we can prevent user to do a nested freeze.
> >>
> >> we can't return error. if we do, the thaw fails with volume still frozen
> >> and no further operation can recover the state.
> >>
> >
> > Taking the superblock lock will prevent this.

could you give me the detail for that?

regards,
wengang.
