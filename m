From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  2 19:40:05 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 5/6] Modify fsck to
 trust global bitmap than super block.take 3
In-Reply-To: <477C530D.4010605@oracle.com>
References: <20071218011410.GA23473@tma-pc1.cn.oracle.com>
	<477C50C5.9060607@oracle.com> <477C530D.4010605@oracle.com>
Message-ID: <477C58A2.7020907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I still need to go thru the fs code for resize. But under what
condition will the global bitmap be updated and not the
superblock?

My problem with the fsck change is that we are manipulating
fs->fs_clusters directly. This will just cause us grief later.
It is best if this is populated only in ocfs2_open().

Sunil

tao.ma wrote:
> Sunil Mushran wrote:
>> Tao Ma wrote:
>>> In resize, we update the global_bitmap first and then the super block.
>>> So if there is any corruption between these 2 steps, there will be a
>>> inconsistence. In kernel we use the information in global_bitmap,
>>> so fsck.ocfs2 should also trust it during the check.
>>>
>>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>>> ---
>>>   
>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>>
>> This looks correct. However, I am still confused as to how I managed to
>> get clean runs when testing aborted offline resize cases.
> In your offline resize design, you write this:
>
>    * Segfault after writing global bitmap but before the superblock.
>
> /fsck will remove all the new BGs that are beyond the end-of-volume as 
> determined by the superblock->num_clusters.
>
>
> So we trust superblock rather than global_bitmap and it works as the 
> design expects when testing aborted offline resize cases.
> Now the order is reversed, so I think maybe I need to revise your 
> design doc so that it doesn't lead to the "strange" result.
> Agree?
> /
