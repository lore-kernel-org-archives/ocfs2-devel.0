From: tao.ma <tao.ma@oracle.com>
Date: Fri Jan  4 00:41:48 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 5/6] Modify fsck
	to trust global bitmap than super block.take 3
In-Reply-To: <477D9A06.3030403@oracle.com>
References: <20071218011410.GA23473@tma-pc1.cn.oracle.com>	<477C50C5.9060607@oracle.com>
	<477C530D.4010605@oracle.com>	<477C58A2.7020907@oracle.com>
	<477C650E.6000909@oracle.com> <477D9A06.3030403@oracle.com>
Message-ID: <477DF136.4020309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> So the problem is as follows:
>
> In offline resize, if we crash after updating globalbitmap but before
> superblock, we have a incompat flag to force users to run fsck to
> fix the volume. Currently our fix in fsck revokes the resize.
That is the old solution. If this patch is merged, we will treat it as 
online resize. That is we will modify the i_cluster in superbock instead 
and the resize is completed by fsck.
>
> If the same crash happened in online, other nodes will carry on
> no problems. The same node can remount the volume and continue.
> The problem will be if someone runs any usertool that writes (say tunefs)
> without running fsck (on the same now unmounted vol).
>
> One solution is to read the global bitmap in ocfs2_open(). If the user
> opens with write and the values are inconsistent, bail unless the tool
> is fsck (via some flag). If the user opens with read, we could ignore
> the inconsistency but use the global bitmap value. My only worry is
> that this will make ocfs2_open() slower. But we can address that later.
Yes, that is what I am thinking.
Since the kernel use the i_clusters in global_bitmap to indicate the 
size of the volume, the user space should also trust that.
>
> Thoughts?
>
> tao.ma wrote:
>> Sunil Mushran wrote:
>>> I still need to go thru the fs code for resize. But under what
>>> condition will the global bitmap be updated and not the
>>> superblock?
>> Actually in kernel, we update the global_bitmap first and then the 
>> super block and backups.
>> And if the super block and backups' update fail, the kernel doesn't 
>> care about it  and only output some in message since the kernel only 
>> use the info stored in global_bitmap.
>>>
>>> My problem with the fsck change is that we are manipulating
>>> fs->fs_clusters directly. This will just cause us grief later.
>>> It is best if this is populated only in ocfs2_open().
>> If we populate in ocfs2_open, maybe we need another flag and check 
>> global_bitmap if needed?
>>>
>>> Sunil
>>>
>>> tao.ma wrote:
>>>> Sunil Mushran wrote:
>>>>> Tao Ma wrote:
>>>>>> In resize, we update the global_bitmap first and then the super 
>>>>>> block.
>>>>>> So if there is any corruption between these 2 steps, there will be a
>>>>>> inconsistence. In kernel we use the information in global_bitmap,
>>>>>> so fsck.ocfs2 should also trust it during the check.
>>>>>>
>>>>>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>>>>>> ---
>>>>>>   
>>>>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>>>>>
>>>>> This looks correct. However, I am still confused as to how I 
>>>>> managed to
>>>>> get clean runs when testing aborted offline resize cases.
>>>> In your offline resize design, you write this:
>>>>
>>>>    * Segfault after writing global bitmap but before the superblock.
>>>>
>>>> /fsck will remove all the new BGs that are beyond the end-of-volume 
>>>> as determined by the superblock->num_clusters.
>>>>
>>>>
>>>> So we trust superblock rather than global_bitmap and it works as 
>>>> the design expects when testing aborted offline resize cases.
>>>> Now the order is reversed, so I think maybe I need to revise your 
>>>> design doc so that it doesn't lead to the "strange" result.
>>>> Agree?
>>>> /
>
