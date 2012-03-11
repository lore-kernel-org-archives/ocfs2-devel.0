From: Kamal Mostafa <kamal@canonical.com>
Date: Sun, 11 Mar 2012 20:23:58 -0000
Subject: [Ocfs2-devel] [PATCH 00/19] Fix filesystem freezing deadlocks
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Message-ID: <1331497364.4641.86.camel@fourier>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com, sandeen@redhat.com, Alex Elder <elder@kernel.org>, Anton Altaparmakov <anton@tuxera.com>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, cluster-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, fuse-devel@lists.sourceforge.net, "J. Bruce Fields" <bfields@fieldses.org>, Joel Becker <jlbec@evilplan.org>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, ocfs2-devel@oss.oracle.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Steven Whitehouse <swhiteho@redhat.com>, Th

On Mon, 2012-03-05 at 17:00 +0100, Jan Kara wrote:
> Hallelujah,
> 
>   after a couple of weeks and several rewrites, here comes the third iteration
> of my patches to improve filesystem freezing.  [...]

We've been testing this patch set at Canonical on the multipath failover
SAN configuration where we originally encountered the freeze deadlock.
We are happy to report that it does appear to fix the problem.  Thanks
Jan!

Please add the following endorsements for these patches (those actually
exercised by our test case):  01, 02, 03, 06, 07, 08, 09, 10, 14, 18, 19

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>

 -Kamal

-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 836 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120311/9f92c086/attachment-0001.bin 
