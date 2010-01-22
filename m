From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 22 Jan 2010 14:35:35 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work
In-Reply-To: <20100122042214.GA3797@laptop.oracle.com>
References: <201001091802.o09I2bB1013187@rcsinet13.oracle.com>
	<4B5122D8.9030400@oracle.com>
	<20100118130638.GA3549@laptop.oracle.com>
	<4B565355.8050406@oracle.com>
	<20100120045531.GA3794@laptop.oracle.com>
	<20100122042214.GA3797@laptop.oracle.com>
Message-ID: <4B5A2837.2000304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
>>>> Though we don't support it, we hope to make the operation succeed.
>>>> the big pain is the we have no way to know if a nested freeze is done
>>>> againt ocfs2 volume. the second freeze doesn't come to ocfs2, it returns
>>>> by vfs(in freeze_bdev()). so we can prevent user to do a nested freeze.
>>>>
>>>> we can't return error. if we do, the thaw fails with volume still frozen
>>>> and no further operation can recover the state.
>>>>
>>> Taking the superblock lock will prevent this.
>
> could you give me the detail for that?

So is your concern racing freeze requests on multiple nodes?

Multiple freeze requests on a single node should work as is because
we only care about the final thaw().

But if there are multiple freeze requests on multiple nodes, both nodes
will race in freeze_fs(sb). The first node to get the sb lock, will attempt
to take the freeze lock. The loser will wait, but it will get the bast 
on the
freeze lock. In it, it will do mutex_trylock(&sb->bdev->bd_fsfreeze_mutex)
and fail.

One solution is for this node to refuse to downconvert the freeze lock. Wait
for the timeout at which time the freezer node will be forced to cancel 
convert.
At that time the loser node will get the freeze lock and everyone will live
happily ever after. ;)

Get my drift.
