From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Tue, 21 Jan 2020 08:18:40 -0800
Subject: [Ocfs2-devel] [Lsf-pc] [LFS/MM TOPIC] fs reflink issues,
 fs online scrub/check, etc
In-Reply-To: <CAOQ4uxjd-YWe5uHqfSW9iSdw-hQyFCwo84cK8ebJVJSY_vda3Q@mail.gmail.com>
References: <20160210191715.GB6339@birch.djwong.org>
	<20160210191848.GC6346@birch.djwong.org>
	<CAH2r5mtM2nCicTKGFAjYtOG92TKKQdTbZxaD-_-RsWYL=Tn2Nw@mail.gmail.com>
	<0089aff3-c4d3-214e-30d7-012abf70623a@gmx.com>
	<CAOQ4uxjd-YWe5uHqfSW9iSdw-hQyFCwo84cK8ebJVJSY_vda3Q@mail.gmail.com>
Message-ID: <20200121161840.GA8236@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Steve French <smfrench@gmail.com>, lsf-pc@lists.linux-foundation.org, xfs <xfs@e29208.dscx.akamaiedge.net>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Tue, Jan 21, 2020 at 09:35:22AM +0200, Amir Goldstein wrote:
> On Tue, Jan 21, 2020 at 3:19 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> > Didn't see the original mail, so reply here.
> 
> Heh! Original email was from 2016, but most of Darrick's wish list is
> still relevant in 2020 :)

Grumble grumble stable behavior of clonerange/deduperange ioctls across
filesystems grumble grumble.

> I for one would be very interested in getting an update on the
> progress of pagecache
> page sharing if there is anyone working on it.

Me too.  I guess it's the 21st, I should really send in a proposal for
*this year's* LSFMMBPFLOLBBQ.

--D

> Thanks,
> Amir.
