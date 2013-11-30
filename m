From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 30 Nov 2013 09:45:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: drop the unwanted null byte in
	dentry lock name
In-Reply-To: <20131128164044.GB29346@wotan.suse.de>
References: <5295B5BC.5020905@huawei.com>
	<20131127153841.4d3414a425d735459288f4ee@linux-foundation.org>
	<20131128164044.GB29346@wotan.suse.de>
Message-ID: <52994320.8000503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/11/29 0:40, Mark Fasheh wrote:
> On Wed, Nov 27, 2013 at 03:38:41PM -0800, Andrew Morton wrote:
>> On Wed, 27 Nov 2013 17:05:00 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
>>
>>> Dentry lock name is made up of the type 'N', the parent blkno and its
>>> blkno represented as a binary value.
>>> Now there is a null byte between parent blkno and the binary blkno
>>> value, so drop it.
>>
>> Geeze.
>>
>> What are the runtime effects of this change?
> 
> This will change the over-the-wire protocol, so big NACK for this
> patch please. Some of the lock names are binary and have been forever now.
> We have a limited amount of space in the name and some lock types would have
> names too long if we stringified every field.
> 	--Mark
> 
What do you mean by change the over-the-wire protocol?
In my opinion, the only thing we should do is to make buildup and parse
consistent.
But if the new version is mixed mounted with the old, it may have
problem because of the changed protocol.

> --
> Mark Fasheh
> 
> 
